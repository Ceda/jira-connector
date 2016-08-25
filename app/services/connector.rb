class Connector
  ISSUE_REGEX = /[A-Za-z]+-[0-9]+/

  LABELS = {
    'Ready for Code Review' => 'Code Review',
    'Ready for QA'          => 'Quality Assurance'
  }

  HEADERS = {
    'Authorization' => "Basic #{JIRA_TOKEN}",
    'Content-Type'  => 'application/json'
  }
end
