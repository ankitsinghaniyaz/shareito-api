Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # NOTE: put the api under subdomain

  resources :users, only: [:create, :show] do
    collection do
      post 'confirm'
      post 'login'
      post 'facebook_login'
    end
  end

  resources :accounts, only: [] do
    collection do
      post 'facebook'
    end
  end
end
