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
    relacion_agenda = RelacionAgendaPlantilla.where(agenda_id:params[:agenda_id],plantilla_id:params[:plantilla_id])
    dias = (agenda.fecha_inicio..agenda.fecha_fin).to_a    
    dias.each do |dia|   
      if dia.wday != 0 && dia.wday != 6  && relacion_agenda.where(dia:dia.strftime("%d")).empty? 
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
    dia = params[:dias].split('_')[0]
    num_dia = params[:dias].split('_')[1]
    logger.debug "********************* dIAS "+params[:dias]
    logger.debug "********************* dIA "+dia
    logger.debug "********************* num_dia "+num_dia
    detalle = DetallePlantilla.find_by(plantilla_id:params[:relacion_agenda_plantilla][:plantilla_id],dia:dia,mesa_id:params[:mesas])
    relacion_agenda = RelacionAgendaPlantilla.new(agenda_id: params[:relacion_agenda_plantilla][:agenda_id],
    plantilla_id: params[:relacion_agenda_plantilla][:plantilla_id],detalle_plantilla_id:detalle.id,user_id:params[:user_id],dia:num_dia,dia_nombre:dia)
    if relacion_agenda.save      
      redirect_to new_relacion_agenda_plantilla_path(agenda_id:params[:relacion_agenda_plantilla][:agenda_id]), notice: "Se ha creado la relación de agenda con plantilla correctamente."
    else
      redirect_to agenda_path(params[:relacion_agenda_plantilla][:agenda_id]), alert: "No se pudo crear la relación de agenda con plantilla."
    end
  end
  
end
