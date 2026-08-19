class PlantillasController < ApplicationController
  def index
    @plantillas = Plantilla.all
  end

  def new
    @plantilla = Plantilla.new
    @mesas = Mesa.all
  end
  def mesas_seleccionadas

    @mesas_seleccionadas = Mesa
    .where(seleccionada: true)
    .includes(:detalle_mesas)   
  end
  def create
    asdasdas
  end
end
