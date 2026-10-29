class PlantillasController < ApplicationController
  include Pagy::Backend
  def index
    @pagy,@plantillas = pagy(Plantilla.all,limit:1)
  end

  def new
    @plantilla = Plantilla.new
    @mesas = Mesa.all.order(:nombre_mesa)    
  end
  def mesas_seleccionadas
    @mesas_seleccionadas = Mesa
    .where(seleccionada: true)
    .includes(:detalle_mesas)   
  end
  def mesas_seleccionadas_2     
    @mesas_seleccionadas = Mesa.where(seleccionada: params[:seleccionada]).order(:nombre_mesa)
    logger.info "Mesas seleccionadas: #{@mesas_seleccionadas.map(&:id).join(', ')}"
    respond_to do |format|
      if params[:ruta] == 1                
        format.turbo_stream { render partial: "plantillas/cargar_mesas_select", 
        locals: { mesas: @mesas_seleccionadas }}
      else        
        format.turbo_stream { render partial: "plantillas/cargar_mesas_select_2", 
        locals: { mesas: @mesas_seleccionadas }}
      end      
    end
  end
  def detalle
     render partial: "template_detalle_mesa"
  end
  def create        
    plantilla = Plantilla.new(nombre: params[:plantilla][:nombre])  
    if plantilla.save      
      params[:mesa][:detalle_mesas_attributes].each do |indice, detalle|
        logger.debug"******* detalle *********** #{detalle}"
        logger.debug"******* detalle mesa *********** #{detalle[:mesa]}"
        tipo = detalle[:tipo].split("_")
        paciente = tipo[0]
        sexo = tipo[1]
        hora = detalle[:horario].split("_")
        horario = hora[1]
        detalle_mesa = DetalleMesa.new(paciente: paciente, sexo: sexo,horario: horario, mesa_id: detalle[:mesa],plantilla_id:plantilla.id)
        detalle_mesa.save
      end            

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
