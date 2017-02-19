class Connector
  ISSUE_REGEX = /[A-Za-z]+-[0-9]+/

  LABELS = {
    'QA Done'               => 'Acceptance Testing',
    'Ready for Code Review' => 'Code Review',
    'Ready for QA'          => 'Quality Assurance',
    'Review Done'           => 'Acceptance Testing',
    # 'WIP'                   => '???'
    # 'Blocked'               => '???',
    # 'Bug'                   => '???',
    # 'Need FIX'              => '???',
    # 'No QA'                 => '???',
    # 'On Production'         => '???',
  }

  USERS = {
    'magnusekm@gmail.com' => 'magnusekm',
    'pleskac@gmail.com'   => 'admin'
  }

  HEADERS = {
    'Authorization' => "Basic #{JIRA_TOKEN}",
    'Content-Type'  => 'application/json'
  }

  def get_issue_code(code, type = nil)
    match = case type
            when 'pull_request' then code['head']['ref'].match(ISSUE_REGEX)
            else
              code.match(ISSUE_REGEX)
            end

    match && match[0]
  end
end
