module GithubApiCalls
  include Variables

  def assign_label_to_issue(label, url)
    RestClient.put "#{url}/labels", [label].to_json,
                                    params: { access_token: GIT_HUB_TOKEN },
                                    accept: :json
  end

  def assign_user_to_issue(user, url)
    RestClient.post "#{url}/assignees", { assignees: user }.to_json,
                                        params: { access_token: GIT_HUB_TOKEN },
                                        accept: :json
  end

  def get_user_by_email(email)
    response = RestClient.get 'https://api.github.com/search/users',
                              params: { q: email, access_token: GIT_HUB_TOKEN },
                              accept: :json

    JSON.parse(response)['items'].first['login']
  end

  def get_user_email(user)
    response = RestClient.get user['url'],
                              params: { access_token: GIT_HUB_TOKEN },
                              accept: :json

    JSON.parse(response)['email']
  end

  def get_issue_url(issue)
    fetch_url    = BB_JIRA_API_V1_URL + "detail?issueId=#{issue['id']}" + '&applicationType=github&dataType=pullrequest'
    response     = JSON.parse(RestClient.get(fetch_url, HEADERS))
    pull_request = response['detail'].first['pullRequests'].select { |pr| pr['status'] == 'OPEN' }

    return false unless pull_request.any?

    'https://api.github.com/repos/' + pull_request.first['url'].match(/(?:.com\/)(.+)/)[1].gsub!('pull', 'issues')
  end
end
