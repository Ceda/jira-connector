require 'base64'

# Credentials
BB_JIRA_URL    = 'https://cedatest.atlassian.net/rest/api/2/issue/'.freeze
GIT_HUB_TOKEN  = 'fcaca0c16d8af65a512e49c00f246c6fc48d0cff'.freeze
JIRA_PASSWORD  = 'cedaceda'.freeze
JIRA_USER_NAME = 'pleskac@gmail.com'.freeze
JIRA_TOKEN     = Base64.encode64('#{JIRA_USER_NAME}:#{JIRA_PASSWORD}').freeze

# Jira Transition IDs
QA_PASSED_ID            = '91'.freeze
REVIEW_PASSED_ID        = '101'.freeze
DEPLOY_READY_ID         = '111'.freeze
CODE_REVIEW_ID          = '11'.freeze
QA_READY_ID             = '12'.freeze
PRODUCTION_VERIFIED_ID  = '12'.freeze
START_PROGRESS_JITR_ID  = '3'.freeze
START_PROGRESS_ID       = '3'.freeze
JIRA_FIELD_BRANCH       = '12'.freeze
JIRA_FIELD_PULL_REQUEST = '12'.freeze
JACKTHREADS_JIRA_URL    = '12'.freeze
QA_READY_JITR_ID        = '12'.freeze
READY_FOR_CR_ID         = '121'.freeze
READY_FOR_QA_ID         = '31'.freeze

JIRA_QA_IMAGE           = 'http://cliparts.co/cliparts/6cp/6Ma/6cp6MaK9i.png'.freeze
JIRA_REVIEW_IMAGE       = 'http://cliparts.co/cliparts/6cp/6Ma/6cp6MaK9i.png'.freeze
