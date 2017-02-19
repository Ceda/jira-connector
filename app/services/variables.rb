module Variables
  ISSUE_REGEX = /[A-Za-z]+-[0-9]+/

  LABELS = {
    'QA Done'               => 'Acceptance Testing',
    'Ready for Code Review' => 'Code Review',
    'Ready for QA'          => 'Quality Assurance',
    'Review Done'           => 'Acceptance Testing',
    'WIP'                   => 'In Progress',
    'On Production'         => 'Done',
    # 'Blocked'               => '???',
    # 'Bug'                   => '???',
    # 'Need FIX'              => '???',
    # 'No QA'                 => '???',
  }

  USERS = {
    'magnusekm@gmail.com' => 'magnusekm',
    'pleskac@gmail.com'   => 'admin'
  }

  HEADERS = {
    'Authorization' => "Basic #{JIRA_TOKEN}",
    'Content-Type'  => 'application/json'
  }
end
