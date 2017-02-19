class GithubConnector
  include Variables
  include GithubApiCalls

  def handle_request(push, event)
    case event
    when 'create'
      handle_branch_create(push)
    when 'pull_request'
      handle_pull_request(push)
    end
  end

  def assign_to_user(issue, change)
    url = get_issue_url issue
    return false unless url

    user = get_user_by_email(find_user(change))

    assign_user_to_issue(user, url)
  end

  def change_labels(issue, change)
    url = get_issue_url issue
    return false unless url

    label = find_label(change)

    assign_label_to_issue(label, url)
  end

  private

  def find_user(change)
    USERS.key change['to'] || change['toString']
  end

  def find_label(change)
    LABELS.key change['toString'] || change['toString']
  end

  def get_issue_code(code, type = nil)
    match = case type
            when 'pull_request' then code['head']['ref'].match(ISSUE_REGEX)
            else
              code.match(ISSUE_REGEX)
            end

    match && match[0]
  end

  def handle_branch_create(push)
    issue = get_issue_code push['ref']
    jira_connector.change_state issue, 'In Progress'
  end

  def handle_pull_request(push)
    action       = push['action']
    pull_request = push['pull_request']
    issue        = get_issue_code pull_request, 'pull_request'
    user         = get_user_email pull_request['assignee']

    case action
    when 'assigned'
      jira_connector.assign_to_user issue, user
    when 'labeled'
      jira_connector.change_state issue, push['label']['name']
    when 'review_requested'
      jira_connector.change_state issue, 'Code Review'
      jira_connector.assign_to_user issue, user
    when 'submitted'
      handle_review(issue, push['review']['state'])
    when 'closed'
      jira_connector.change_state issue, 'Done'
    when 'opened'
      jira_connector.change_state issue, 'In Progress'
    end
  end

  def handle_review(issue, state)
    case state
    when 'approved'
      jira_connector.change_state issue, 'Quality Assurance'
    when 'changes_requested'
      jira_connector.change_state issue, 'To Do'
    end
  end
end
