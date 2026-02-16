Rails.application.routes.draw do
  root "patients#index"

  resources :patients, only: [:index, :create, :show, :destroy] do
    resources :tension_days do
      collection do
        get :results
        post :export_pdf
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
