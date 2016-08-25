class InterceptionsController < ApplicationController
  skip_before_action  :verify_authenticity_token

  def jira
    push   = JSON.parse(request.body.read)
    issue  = push['issue']['key']                        # TEST-27
    user   = push['user']['emailAddress']                # magnusekm@gmail.com
    change = push['changelog']['items'].find { |c| c['field'] == 'status' }
    # {
    #   "field"=>"status",
    #   "fieldtype"=>"jira",
    #   "from"=>"10000",
    #   "fromString"=>"To Do",
    #   "to"=>"3",
    #   "toString"=>"In Progress"
    # }

    render nothing: true, status: 200
  end

  def github
    event = request.env['HTTP_X_GITHUB_EVENT']
    push  = JSON.parse(request.body.read)

    github_connector.handle_pull_request(push) if event == 'pull_request'

    # elsif event == 'create' && push['ref_type'] == 'branch'
    #   branch      = push['ref']
    #   user        = github_connector.get_user push['sender']
    #   issue       = jira_connector.get_issue branch, 'branch', true
    #   jira_connector.start_progress issue, user, branch
    # end

    render nothing: true, status: 200
  end

  private

  def jira_connector
    JiraConnector.new
  end

  def github_connector
    GithubConnector.new
  end
end
