Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resource :auth, controller: :auth, only: [] do
        collection do
          post :token, action: :generate_token
          get :validate, action: :validate_token
        end
      end

      resources :invoices, only: %i(create)
    end
  end
end
