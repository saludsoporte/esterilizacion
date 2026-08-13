class PlantillasController < ApplicationController
  def index
    @plantillas = Plantilla.all
  end

  def new
    @plantilla = Plantilla.new
  end
end
