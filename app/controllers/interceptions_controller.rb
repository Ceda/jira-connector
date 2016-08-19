class InterceptionsController < ApplicationController
  def jira
    push       = JSON.parse(request.body.read)
    issue      = push['issue']['key']
    transition = push['changelog']['items'].last['to'].to_s
    user       = "[~#{push['user']['key']}]"

    case transition
    when START_PROGRESS_ID
      JiraConnector.start_progress issue, user
    when QA_READY_ID
      JiraConnector.start_qa issue, user
    end
  end

  def github
    event = request.env['HTTP_X_GITHUB_EVENT']
    push  = JSON.parse(request.body.read)

    if event == 'pull_request'
      GithubConnector.handle_pull_request push
    elsif event == 'create' && push['ref_type'] == 'branch'
      branch      = push['ref']
      user        = GithubConnector.get_user push['sender']
      issue       = JiraConnector.get_issue branch, 'branch', true
      JiraConnector.start_progress issue, user, branch
    end
  end
end
