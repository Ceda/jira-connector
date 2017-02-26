class JiraConnector
  include Variables

  def assign_to_user(issue, user)
    return false unless issue && user

    url = BB_JIRA_API_V2_URL + issue

    JiraClient.put(url, { fields: { assignee: { name: USERS[user] } } })
  end

  def change_state(issue, label)
    return false unless issue

    url = BB_JIRA_API_V2_URL + issue + '/transitions'

    transition = find_transition label, JSON.parse(RestClient.get(url, HEADERS))
    if transition
      JiraClient.post(url, { transition: { id: transition['id'] } })
    else
      Rails.logger.error 'Cannot transition this ticket'
      false
    end
  end

  def get_issue_url(issue)
    fetch_url    = BB_JIRA_API_V1_URL + "detail?issueId=#{issue['id']}" + '&applicationType=github&dataType=pullrequest'
    response     = JSON.parse(JiraClient.get(fetch_url))
    pull_request = response['detail'].first['pullRequests'].select { |pr| pr['status'] == 'OPEN' }

    return false unless pull_request.any?

    'https://api.github.com/repos/' + pull_request.first['url'].match(/(?:.com\/)(.+)/)[1].gsub!('pull', 'issues')
  end

  private

  def find_transition(label, available_transitions)
    state = LABELS[label] || label
    available_transitions['transitions'].find do |transition|
      transition['to']['name'] == state
    end
  end
end
