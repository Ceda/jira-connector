class GithubController < HandleController
  def index
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'create'
      issue = get_issue_code push['ref']
      Connector.jira.change_state issue, 'In Progress'
    when 'pull_request'
      action       = push['action']
      pull_request = push['pull_request']
      issue        = get_issue_code pull_request, 'pull_request'
      user         = get_user_email pull_request['assignee']

      case action
      when 'assigned'
        Connector.jira.assign_to_user issue, user
      when 'labeled'
        Connector.jira.change_state issue, push['label']['name']
      when 'review_requested'
        Connector.jira.change_state issue, 'Code Review'
        Connector.jira.assign_to_user issue, user
      when 'submitted'
        case push['review']['state']
        when 'approved'
          Connector.jira.change_state issue, 'Quality Assurance'
        when 'changes_requested'
          Connector.jira.change_state issue, 'To Do'
        end
      when 'closed'
        Connector.jira.change_state issue, 'Done'
      when 'opened'
        Connector.jira.change_state issue, 'In Progress'
      end
    end

    render body: nil, status: 200
  end

  private

  def get_issue_code(code, type = nil)
    match = case type
            when 'pull_request' then code['head']['ref'].match(ISSUE_REGEX)
            else
              code.match(ISSUE_REGEX)
            end

    match && match[0]
  end
end
