Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      resources :users, only: %i[index show], format: 'json'
      resources :topics, only: %i[index show], format: 'json'
      resources :targets, only: %i[index show]
      get :status, to: 'api#status'
    end
  end

  root 'api/v1/users#index'
end
