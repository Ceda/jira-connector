class GithubConnector
  include Variables

  def assign_to_user(issue, change)
    url = Connector.jira.get_issue_url issue
    return false unless url

    user = get_user_by_email(find_user(change))

    GithubClient.post "#{url}/assignees", { assignees: user }
  end

  def change_labels(issue, change)
    url = Connector.jira.get_issue_url issue
    return false unless url

    label = find_label(change)

    GithubClient.put "#{url}/labels", [label]
  end

  def get_user_by_email(email)
    JSON.parse(GithubClient.search_user(email))['items'].first['login']
  end

  def get_user_email(user)
    response = GithubClient.get user['url']

    JSON.parse(response)['email']
  end

  private

  def find_user(change)
    USERS.key change['to'] || change['toString']
  end

  def find_label(change)
    LABELS.key change['toString'] || change['toString']
  end
end
