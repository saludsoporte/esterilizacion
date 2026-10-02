class NotificacionesController < ApplicationController
 before_action :authenticate_user!

  def index
    @notificaciones = current_user.notificaciones
                                  .includes(:cita)
                                  .order(created_at: :desc)
  end

  def marcar_leida
    notificacion = current_user.notificaciones.find(params[:id])

    notificacion.update(leida: true)

    redirect_to notificaciones_path
  end

  def marcar_todas_leidas
    current_user.notificaciones.no_leidas.update_all(leida: true)

    redirect_to notificaciones_path
  end

end
