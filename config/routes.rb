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
  post "relacion_agenda_plantilla/agregar_medico",
     to: "relacion_agenda_plantillas#agregar_medico",
     as: :agregar_medico_relacion_agenda
  # Usuarios
  # La creación (new/create) la maneja Devise.
  # Estas acciones las maneja UsersController.
  post "relacion_agenda_plantillas/setDiasMeses", to: "relacion_agenda_plantillas#setDiasMeses"
  post "relacion_agenda_plantillas/setMesas", to: "relacion_agenda_plantillas#setMesas"  
  post "relacion_agenda_plantillas/:id/setMesa", to: "relacion_agenda_plantillas#setMesa"  
  post "relacion_agenda_plantillas/editRelacion", to: "relacion_agenda_plantillas#editRelacion"
  get "relacion_agenda_plantillas/editar_relaciones", to: "relacion_agenda_plantillas#editar_relaciones"
  resources :users
  resources :relacion_agenda_plantillas

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

end
