class HandleController < ApplicationController
  skip_before_action :verify_authenticity_token
  # include CaptureRequests

  private

  def push
    JSON.parse(request.body.read)
  end
end
