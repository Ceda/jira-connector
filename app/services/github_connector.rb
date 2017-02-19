class GithubConnector < Connector
  def handle_pull_request(push)
    action         = push['action']
    user           = get_user_email push['sender']
    pull_request   = push['pull_request']
    issue          = jira_connector.get_issue pull_request, 'pull_request'

    if action == 'labeled'
      jira_connector.change_state issue, push['label']['name'], user
    end
  end

  def get_user_email(user)
    response = RestClient.get user['url'],
                              params: { access_token: GIT_HUB_TOKEN },
                              accept: :json

    JSON.parse(response)['email']
  end

  def get_issue_url(issue)
    url = BB_JIRA_API_V1_URL + "detail?issueId=#{issue['id']}" + '&applicationType=github&dataType=pullrequest'

    response = JSON.parse(RestClient.get(url, HEADERS))

    url = response['detail'].first['pullRequests'].last['url']

    'https://api.github.com/repos/' + url.match(/(?:.com\/)(.+)/)[1].gsub!('pull', 'issues')
  end

  def change_labels(url, labels)
    RestClient.put "#{url}/labels", [labels].to_json,
                  params: { access_token: GIT_HUB_TOKEN },
                  accept: :json
  end

  def find_label(change)
    LABELS.key change['toString'] || change['toString']
  end
end
