Rails.application.routes.draw do

  # Plantillas
  resources :plantillas do
    collection do
      get :mesas_seleccionadas
    end
  end

  # Mesas
  resources :mesas do
    member do
      patch :seleccionar
    end
  end

  # Agendas
  resources :agendas

  # Agregar detalle de mesa
  get "mesas/agregar_detalle", to: "mesas#agregar_detalle"

  # Home
  get "home/index"
  root "home#index"

  # Ajustes / administración
  get "home/ajustes", as: :admin
  get "home/usuarios", to: "home#usuarios"

  # Devise
  devise_for :users, controllers: {sessions: "users/sessions"}
  post "users/nuevo_usuario", to: "users#nuevo_usuario"

  # Usuarios
  # La creación (new/create) la maneja Devise.
  # Estas acciones las maneja UsersController.
   resources :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

end
