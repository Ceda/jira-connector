class Connector
  def self.jira
    @jira ||= JiraConnector.new
  end

  def self.github
    @github ||= GithubConnector.new
  end
end
