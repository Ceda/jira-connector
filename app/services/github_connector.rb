class GithubConnector < Connector
  def handle_pull_request(push)
    action       = push['action']
    user         = get_user push['sender']
    pull_request = push['pull_request']
    jira_issues  = get_jira_issues pull_request, 'pull_request', false

    if action == 'labeled'
      pull_request_labels = get_labels pull_request
      current_label       = push['label']['name']
      update_label_jira jira_issues, current_label, pull_request_labels, user

    elsif action == 'synchronize'
      latest_commit_message = get_latest_commit_message pull_request, push['repository']['commits_url']
      update_message_jira jira_issues, pull_request, latest_commit_message, user, false

    elsif action == 'opened'
      start_code_review jira_issues, pull_request, user
    end
  end

  def get_latest_commit_message(pull_request, commits_url)
    url = commits_url.split('{')[0] + '/' + pull_request['head']['sha']
    latest_commit_info = JSON.parse(RestClient.get(url, params: { access_token: GIT_HUB_TOKEN }, accept: :json))
    latest_commit_info['commit']['message']
  end

  def get_labels(pull_request)
    labels_url = pull_request['issue_url'] + '/labels'
    JSON.parse(RestClient.get(labels_url, params: { access_token: GIT_HUB_TOKEN }, accept: :json))
  end

  def get_user(user_object)
    user_info = JSON.parse(RestClient.get(user_object['url'], params: { access_token: GIT_HUB_TOKEN }, accept: :json))

    if !user_info['email'].nil?
      user_email_domain = user_info['email'].split('@')[1]
      user_email_prefix = user_info['email'].split('@')[0]

      if user_email_domain == 'thrillist.com'
        user = user_email_prefix.insert(0, '[~') + ']'
      end
    else
      user = '[' + user_object['login'] + '|' + user_object['html_url'] + ']'
    end

    case user_object['login']
    when 'Ceda'
      user = '[~admin]'
    end

    user
  end
end
