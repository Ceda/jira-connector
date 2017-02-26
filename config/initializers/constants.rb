require 'base64'

BB_JIRA_API_V1_URL = 'https://cedatest.atlassian.net/rest/dev-status/1.0/issue/'.freeze
BB_JIRA_API_V2_URL = 'https://cedatest.atlassian.net/rest/api/2/issue/'.freeze

GIT_HUB_TOKEN      = ENV['GITHUB_TOKEN']
JIRA_PASSWORD      = ENV['JIRA_PASSWORD']
JIRA_USER_NAME     = ENV['JIRA_USER_NAME']

JIRA_TOKEN         = Base64.encode64("#{JIRA_USER_NAME}:#{JIRA_PASSWORD}").freeze
