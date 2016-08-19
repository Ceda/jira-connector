require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module JiraTransitionRails5
  class Application < Rails::Application
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
  end
end
