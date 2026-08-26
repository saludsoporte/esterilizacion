class RelacionAgendaPlantillasController < ApplicationController
  before_action :authenticate_user!
  def new
    @relacion = RelacionAgendaPlantilla.new
    @agenda = Agenda.find(params[:agenda])
  end
  
end
