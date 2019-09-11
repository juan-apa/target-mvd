Rails.application.routes.draw do
  # get 'user/index'
  # get 'user/show'
  # get 'user/create'
  # get 'user/update'
  # get 'user/destroy'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
