Rails.application.routes.draw do
  devise_for :administrators

  post :github, to: 'interceptions#github'
  post :jira,   to: 'interceptions#jira'

  root to: 'root#index'
end
