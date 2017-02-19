class GithubConnector < Connector
  def handle_request(push, event)
    # request_headers
    #  # create_branch    "HTTP_X_GITHUB_EVENT"=>"create",
    #  # create_pr        "HTTP_X_GITHUB_EVENT"=>"pull_request",
    #  # delete_branch    "HTTP_X_GITHUB_EVENT"=>"delete",
    #  # review_requested "HTTP_X_GITHUB_EVENT"=>"pull_request",

    case event
    when 'create'
      handle_branch_create(push)
    when 'pull_request'
      handle_pull_request(push)
    end
  end

  def get_issue_url(issue)
    fetch_url = BB_JIRA_API_V1_URL + "detail?issueId=#{issue['id']}" + '&applicationType=github&dataType=pullrequest'
    response  = JSON.parse(RestClient.get(fetch_url, HEADERS))

    url = response['detail'].first['pullRequests'].select { |pr| pr['status'] == 'OPEN' }.first['url']

    'https://api.github.com/repos/' + url.match(/(?:.com\/)(.+)/)[1].gsub!('pull', 'issues')
  end

  def change_labels(issue, change)
    url   = get_issue_url issue
    label = find_label(change)

    RestClient.put "#{url}/labels", [label].to_json,
                  params: { access_token: GIT_HUB_TOKEN },
                  accept: :json
  end

  def find_label(change)
    LABELS.key change['toString'] || change['toString']
  end

  private

  def handle_branch_create(push)
    issue = get_issue push['ref']
    jira_connector.change_state issue, 'In Progress'
  end

  def handle_pull_request(push)
    action       = push['action']
    pull_request = push['pull_request']
    issue        = get_issue pull_request, 'pull_request'
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

  def get_user_email(user)
    response = RestClient.get user['url'],
                              params: { access_token: GIT_HUB_TOKEN },
                              accept: :json

    JSON.parse(response)['email']
  end
end
