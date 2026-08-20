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
    plantilla = Plantilla.new(nombre: params[:plantilla][:nombre])  
    if plantilla.save
      params[:plantilla][:dias].each do |dia, datos|      
        # Process each day
        logger.info "Processing day: #{dia.upcase} at index #{datos}"
        datos[:mesa_ids].each do |mesa_id|
          logger.info "Processing mesa_id: #{mesa_id}"
          detalle_pl = DetallePlantilla.new(           
            dia: dia.upcase,
            mesa_id: mesa_id,
            plantilla_id: plantilla.id
          )
          if detalle_pl.save
            logger.info "Detalle plantilla saved successfully for day: #{dia.upcase} and mesa_id: #{mesa_id}"
          else
            logger.error "Error saving detalle plantilla for day: #{dia.upcase} and mesa_id: #{mesa_id}: #{detalle_pl.errors.full_messages.join(", ")}"
          end
        end
      end
    end
    mesas_seleccionadas = Mesa.where(seleccionada: true)
    mesas_seleccionadas.update_all(seleccionada: false)
    redirect_to plantillas_path, notice: "Plantilla creada correctamente."
  end
end
