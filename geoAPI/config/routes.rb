Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome_page/index'

  resources :centre_point

  root 'welcome#index'
end
