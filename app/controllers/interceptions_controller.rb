# class InterceptionsController < ApplicationController
#   skip_before_action :verify_authenticity_token
#   # include CaptureRequests
#
#   def jira
#     push = JSON.parse(request.body.read)
#
#     Connector.jira.handle_request(push)
#
#     render body: nil, status: 200
#   end
#
#   def github
#     event = request.env['HTTP_X_GITHUB_EVENT']
#     push  = JSON.parse(request.body.read)
#
#     Connector.github.handle_request(push, event)
#
#     render body: nil, status: 200
#   end
# end
