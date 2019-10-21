Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions',
    passwords: 'api/v1/passwords'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      # resources :abouts, only: %i[:index :show], format: 'json'
      get '/about', to: 'abouts#index'
      resources :users, only: %i[index show], format: 'json'
      resources :topics, only: %i[index show], format: 'json'
      resources :targets, only: %i[index show create destroy]
      resources :conversations, only: [] do
        resources :messages, only: %i[index create]
      end
      resources :matches, only: %i[index show]
      get :status, to: 'api#status'
    end
  end
end
