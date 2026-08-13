# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  #POST /resource/sign_in
  def create
    super # do |user|
     # if user.admin?
     #   flash[:notice] = "Bienvenido Administrador"
     # else
     #   flash[:notice] = "Bienvenido"      
     # end
    #end
  end
  def after_sign_in_path_for(resource)
    if resource.rols_id == 1
      admin_path
    else
      root_path
    end
  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
