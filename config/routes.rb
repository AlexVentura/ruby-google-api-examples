Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/sheets'
  get 'welcome/demo_net'
  get 'welcome/demo_link'

  root to: 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
