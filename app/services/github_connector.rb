class GithubConnector < Connector
  def handle_pull_request(push)
    action       = push['action']
    user         = get_user_email push['sender']
    pull_request = push['pull_request']
    jira         = JiraConnector.new
    issue        = jira.get_issue pull_request, 'pull_request'

    if action == 'labeled'
      jira.change_state issue, push['label']['name'], user
    end

    # elsif action == 'opened'
    #   start_code_review issue, pull_request, user
    # end
  end

  # def get_labels(pull_request)
  #   labels_url = pull_request['issue_url'] + '/labels'
  #   JSON.parse(RestClient.get(labels_url, params: { access_token: GIT_HUB_TOKEN }, accept: :json))
  # end

  def get_user_email(user)
    response = RestClient.get user['url'],
                              params: { access_token: GIT_HUB_TOKEN },
                              accept: :json

    JSON.parse(response)['email']
  end
end
