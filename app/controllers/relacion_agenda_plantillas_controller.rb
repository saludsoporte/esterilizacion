class RelacionAgendaPlantillasController < ApplicationController
  before_action :authenticate_user!


  def new
    @relacion_agenda_plantilla = RelacionAgendaPlantilla.new
    @agenda = Agenda.find(params[:agenda_id])
  end
  def agregar_medico
    @medico = User.find(params[:user_id])
  end
  def setDiasMeses
      dias_semana = {
      0 => "DOMINGO",
      1 => "LUNES",
      2 => "MARTES",
      3 => "MIERCOLES",
      4 => "JUEVES",
      5 => "VIERNES",
      6 => "SABADO"
    }
    nombre_dias = []
    agenda = Agenda.find(params[:agenda_id])
    dias = (agenda.fecha_inicio..agenda.fecha_fin).to_a
    dias.each do |dia|
      if !nombre_dias.include?(dias_semana[dia.wday])         
        nombre_dias.push(dias_semana[dia.wday])
      end
    end
    detalles = DetallePlantillas.where(plantilla_id:params[:plantilla_id])
    respond_to do |format|
      format.turbo_stream { render partial: "relacion_agenda_plantillas/cargar_dias_mesas", 
      locals: { detalles: detalles }}
    end
  end
  
end
