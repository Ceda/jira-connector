Rails.application.routes.draw do
  devise_for :administrators

  post :github, to: 'github#index'
  post :jira,   to: 'jira#index'

  root to: 'root#index'
end
