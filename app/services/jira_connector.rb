class JiraConnector < Connector
  def handle_request(push)
    change = get_change(push)

    case change['field']
    when 'status'
      github_connector.change_labels(push['issue'], change)
    when 'assignee'
      github_connector.assign_to_user(push['issue'], change)
    end
  end

  def assign_to_user(issue, user)
    return false unless issue && user

    url = BB_JIRA_API_V2_URL + issue

    RestClient.put(url, { fields: { assignee: { name: USERS[user] } } }.to_json, HEADERS)
  end

  def change_state(issue, label)
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

  def get_change(push)
    push['changelog']['items'].first
  end

  def find_transition(label, available_transitions)
    state = LABELS[label] || label
    available_transitions['transitions'].find do |transition|
      transition['to']['name'] == state
    end
  end
end
