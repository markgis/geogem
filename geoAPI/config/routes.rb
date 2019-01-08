Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome_page/index'

  root 'welcome#index'
end
