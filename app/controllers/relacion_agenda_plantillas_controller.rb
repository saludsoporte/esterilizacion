class RelacionAgendaPlantillasController < ApplicationController
  before_action :authenticate_user!
  def new
    @relacion_agenda_plantilla = RelacionAgendaPlantilla.new
    @agenda = Agenda.find(params[:agenda])
  end
  def agregar_medico
    @medico = User.find(params[:user_id])
  end
  
end
