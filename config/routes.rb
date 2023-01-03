Rails.application.routes.draw do
  resource :example, constraints: -> { Rails.env.development? }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "listings#index"
end
