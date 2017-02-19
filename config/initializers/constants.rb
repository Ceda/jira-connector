require 'base64'

# Credentials
BB_JIRA_API_V1_URL = 'https://cedatest.atlassian.net/rest/dev-status/1.0/issue/'.freeze
BB_JIRA_API_V2_URL = 'https://cedatest.atlassian.net/rest/api/2/issue/'.freeze

GIT_HUB_TOKEN      = ENV['GITHUB_TOKEN']
JIRA_PASSWORD      = ENV['JIRA_PASSWORD']
JIRA_USER_NAME     = 'pleskac@gmail.com'.freeze
JIRA_TOKEN         = Base64.encode64("#{JIRA_USER_NAME}:#{JIRA_PASSWORD}").freeze

JIRA_QA_IMAGE      = 'http://cliparts.co/cliparts/6cp/6Ma/6cp6MaK9i.png'.freeze
JIRA_REVIEW_IMAGE  = 'http://cliparts.co/cliparts/6cp/6Ma/6cp6MaK9i.png'.freeze
