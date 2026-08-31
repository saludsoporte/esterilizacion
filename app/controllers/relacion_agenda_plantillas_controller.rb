class RelacionAgendaPlantillasController < ApplicationController
  before_action :authenticate_user!


  def new
    @relacion_agenda = RelacionAgendaPlantilla.new
    @agenda = Agenda.find(params[:agenda_id])
  end
  def agregar_medico
    @medico = User.find(params[:user_id])
  end
  def setDiasMeses
      dias_semana = {      
      1 => "LUNES",
      2 => "MARTES",
      3 => "MIERCOLES",
      4 => "JUEVES",
      5 => "VIERNES"      
    }
    nombre_dias = []
    agenda = Agenda.find(params[:agenda_id])
    dias = (agenda.fecha_inicio..agenda.fecha_fin).to_a    
    dias.each do |dia|   
      if dia.wday != 0 && dia.wday != 6   
        nombre_dias.push({dias:dias_semana[dia.wday],num:dia.strftime("%d")})      
      end
    end
    detalles = DetallePlantilla.where(plantilla_id:params[:plantilla_id])
    respond_to do |format|
      format.turbo_stream { render partial: "relacion_agenda_plantillas/cargar_dias_mesas", 
      locals: { detalles: detalles, dias: nombre_dias }}
    end
  end
  def setMesas
    dia = params[:dia].split('_')[0]
    num_dia = params[:dia].split('_')[1]
    logger.debug "********************* dIAS "+params[:dia]
    logger.debug "********************* dIA "+dia
    detalle = DetallePlantilla.where(plantilla_id:params[:plantilla_id],dia:dia)
    logger.debug "********************* mesas "+detalle.count.to_s
    respond_to do |format|
      format.turbo_stream { render partial: "relacion_agenda_plantillas/cargar_mesas", 
      locals: { detalles: detalle}}
    end
  end

  def create
    asdad
  end
  
end
