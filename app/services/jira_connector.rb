class JiraConnector < Connector
  def handle_request(push)
    issue  = push['issue']['key']
    change = push['changelog']['items'].find { |c| c['field'] == 'status' }

    url = github_connector.get_issue_url push['issue']
    label = github_connector.find_label(change)

    github_connector.change_labels(url, label)
  end

  def get_issue(code, type)
    match = case type
            when 'branch'       then code.match(ISSUE_REGEX)
            when 'pull_request' then code['head']['ref'].match(ISSUE_REGEX)
            end

    match && match[0]
  end

  def change_state(issue, label, _user)
    return false unless issue

    url = BB_JIRA_API_V2_URL + issue + '/transitions'

    transition = find_transition label, JSON.parse(RestClient.get(url, HEADERS))
    if transition
      RestClient.post(url, { transition: { id: transition['id'] } }.to_json, HEADERS)
    else
      Rails.logger.error 'Cannot transition this ticket'
      false
    end
  end

  private

  def find_transition(label, available_transitions)
    state = LABELS[label] || label
    available_transitions['transitions'].find do |transition|
      transition['to']['name'] == state
    end
  end
end
