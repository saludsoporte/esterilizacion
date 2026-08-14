class PlantillasController < ApplicationController
  def index
    @plantillas = Plantilla.all
  end

  def new
    @plantilla = Plantilla.new
    @mesas = Mesa.all
  end
end
