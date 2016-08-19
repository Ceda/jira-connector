class JiraConnector < Connector
  def get_issue(code, type)
    issue = if type == 'branch'
              code.scan(issue_regex)
            elsif type == 'pull_request'
              code['head']['ref'].scan(issue_regex)
            end
  end

  def update_label(issue, current_label, pull_request_labels, user)
    unless issue.nil?
      case current_label
      when 'Ready for Code Review'
        transition_issue issue, READY_FOR_CR_ID, user
      when 'Ready for QA'
        transition_issue issue, READY_FOR_QA_ID, user
        unless pull_request_labels.find { |label| label['name'] == 'reviewed' }.nil?
          transition_issue issue, DEPLOY_READY_ID, user
        end
      when 'Production verified'
        transition_issue issue, PRODUCTION_VERIFIED_ID, user
      end
    end
  end

  def update_message(issue, pull_request, latest_message, user)
    if !latest_message.scan(/(?:\s|^)([A-Za-z]+-[0-9]+).+(#comment)(?=\s|$)/).empty?
      apply_comment = false
    else
      apply_comment = true
    end

    if apply_comment == true
      transition_issue issue, QA_READY_ID, user, pull_request, 'updated', latest_message
    end
  end

  def start_qa(issue, pull_request, user, _is_jitr)
    transition_issue issue, QA_READY_ID, user, pull_request, 'opened'
  end

  def start_code_review(issue, pull_request, user)
    transition_issue issue, CODE_REVIEW_ID, user, pull_request, 'opened'
  end

  def start_progress(issue, user, *branch)
    i = 0
    if !branch[0].nil?
      transition_issue issue, START_PROGRESS_JITR_ID, user, branch[0], 'created', 'jitr'
    else
      transition_issue issue, START_PROGRESS_ID, user
    end
  end

  def update_development_info(issue, name, type)
    field = if type == 'branch'
              JIRA_FIELD_BRANCH
            elsif type == 'pull_request'
              JIRA_FIELD_PULL_REQUEST
            end

    data = {
      'fields' => {
        field => name
      }
    }.to_json

    url = JIRA_URL + issue

    RestClient.put(url, data, headers)
  end

  def transition_issue(issue, update_to, user, *code_info)
    url = BB_JIRA_URL + issue + '/transitions'

    case update_to
    when START_PROGRESS_JITR_ID
      body = "Progress started when #{user} created branch: #{code_info[0]} in GitHub"
    when START_PROGRESS_ID
      body = "Progress started when #{user} began working on a story in this epic"
    when CODE_REVIEW_ID
      body = "#{user} opened pull request: [#{code_info[0]['title']}|#{code_info[0]['html_url']}]. Ready for Code Review"
    when QA_READY_JITR_ID
      if code_info[0].nil?
        body = "A story for this epic has been submitted to QA by #{user}."
      elsif code_info[1] == 'opened'
        body = "#{user} opened pull request: [#{code_info[0]['title']}|#{code_info[0]['html_url']}]. Ready for QA"
      elsif code_info[1] == 'updated'
        body = "#{user} updated pull request: [#{code_info[0]['title']}|#{code_info[0]['html_url']}] with comment: \n bq. #{code_info[2]}"
      end
    when QA_READY_ID
      if code_info[1] == 'updated'
        body = "#{user} updated pull request: [#{code_info[0]['title']}|#{code_info[0]['html_url']}] with comment: \n bq. #{code_info[2]}"
      else
        body = "Code review passed by #{user} #{JIRA_REVIEW_IMAGE}"
      end
    when QA_PASSED_ID
      body = "QA passed by #{user} #{JIRA_QA_IMAGE}"
    when REVIEW_PASSED_ID
      body = "Code review passed by #{user} #{JIRA_REVIEW_IMAGE}"
    when DEPLOY_READY_ID
      body = 'Deploy ready'
    end

    data = {
      'update' => {
        'comment' => [
          {
            'add' => {
              'body' => body
            }
          }
        ]
      },
      'transition' => {
        'id' => update_to.to_s
      }
    }.to_json

    if update_to == START_PROGRESS_JITR_ID || update_to == QA_READY_JITR_ID
      case update_to
      when START_PROGRESS_JITR_ID
        field = JIRA_FIELD_BRANCH
        data = {
          'update' => {
            'comment' => [
              {
                'add' => {
                  'body' => body
                }
              }
            ],
            field     => [
              {
                'set' => code_info[0].to_s
              }
            ]
          },
          'transition' => {
            'id' => update_to.to_s
          }
        }.to_json
      when QA_READY_JITR_ID
        field = JIRA_FIELD_PULL_REQUEST

        data = {
          'update' => {
            'comment' => [
              {
                'add' => {
                  'body' => body
                }
              }
            ],
            field => [
              {
                'set' => code_info[0]['html_url'].to_s
              }
            ]
          },
          'transition' => {
            'id' => update_to.to_s
          }
        }.to_json

      end
      data.to_json
    end

    available_transitions = JSON.parse(RestClient.get(url, headers))

    if able_to_transition? update_to, available_transitions
      RestClient.post(url, data, headers)
    else
      logger.error { 'cannot transition this ticket' }
    end
  end

  def able_to_transition?(update_to, available_transitions)
    able_to_transition = false

    i = 0
    while i < available_transitions['transitions'].length
      available_transition = available_transitions['transitions'][i]
      if available_transition['id'] == update_to
        able_to_transition = true
        i += available_transitions['transitions'].length
      end
      i += 1
    end
    able_to_transition
  end
end
