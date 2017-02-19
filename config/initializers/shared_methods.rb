def jira_connector
  @jira_connector ||= JiraConnector.new
end

def github_connector
  @github_connector ||= GithubConnector.new
end
