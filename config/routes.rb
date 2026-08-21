Rails.application.routes.draw do
  get 'users/index'
  get 'users/new'
  get 'users/edit'
  get 'mesas/new'
  resources :plantillas do
    collection do
      get :mesas_seleccionadas
    end
  end
  resources :mesas do
    member do
      patch :seleccionar
    end
  end
  resources :agendas
  resources :plantillas  
  resources :mesas
  
  
  get "mesas/agregar_detalle", to: "mesas#agregar_detalle"
  get 'home/index'
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }
  root "home#index"
  get 'home/ajustes', as: :admin
  get 'home/usuarios', to: "home#usuarios"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users
end
