module CaptureRequests
  extend ActiveSupport::Concern

  included do
    before_action :capture_request
  end

  def capture_request
    File.open('capture.json', 'w+') do |f|
      f.write(request.body.read)
    end
  end
end
