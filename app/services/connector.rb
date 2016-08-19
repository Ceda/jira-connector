class Connector
  issue_regex = '/(?:|^)([A-Za-z]+-[0-9]+)(?=|$)/'

  headers = {
    'Authorization' => "Basic #{JIRA_TOKEN}",
    'Content-Type'  => 'application/json'
  }
end
