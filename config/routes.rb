Rails.application.routes.draw do
  devise_for :administrators

  post :github, to: 'interception#github'
  post :jira, to: 'interception#jira'

  root to: 'root#index'
end
