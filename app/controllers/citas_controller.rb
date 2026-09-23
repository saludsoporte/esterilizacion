class CitasController < ApplicationController
  before_action :set_cita, only: %i[ show edit update destroy ]
   before_action :cargar_catalogos, only: %i[new edit]

  # GET /citas or /citas.json
  def index
    @citas = Cita.all
  end

  # GET /citas/1 or /citas/1.json
  def show
  end

  # GET /citas/new
  def new
    @cita = Cita.new
  end

  # GET /citas/1/edit
  def edit
  end

  # POST /citas or /citas.json
  def create
    @cita = Cita.new(cita_params)

    respond_to do |format|
      if @cita.save
        format.html { redirect_to @cita, notice: "Cita was successfully created." }
        format.json { render :show, status: :created, location: @cita }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @cita.errors, status: :unprocessable_content }
      end
    end
  end
  def citasPosibles(dia,paciente,sexo,plantilla)
    citas_posibles = 0
    mesas = DetallePlantilla.where(dia:dia,plantilla_id:plantilla)
    logger.debug("************ #{mesas.count}")
    mesas.each do |mesa|
      citas_posibles += DetalleMesa.where(mesa_id:mesa.mesa_id,paciente: paciente,sexo:sexo).count  
    end
    return citas_posibles
  end
  def setDiasDisponibles
    @agenda = Agenda.where(activo:true).order(id: :desc).first
    
    
    paciente = params[:paciente] == 'Perro' ? 'C' : 'F'
    sexo = params[:sexo] == 'Hembra' ? 'H' : 'M'
    dias_citas = [      
      ["LUNES", citasPosibles("LUNES",paciente,sexo,@agenda.plantilla.id)],
      ["MARTES", citasPosibles("MARTES",paciente,sexo,@agenda.plantilla.id)],
      ["MIERCOLES",citasPosibles("MIERCOLES",paciente,sexo,@agenda.plantilla.id)],
      ["JUEVES", citasPosibles("JUEVES",paciente,sexo,@agenda.plantilla.id)],
      ["VIERNES",citasPosibles("VIERNES",paciente,sexo,@agenda.plantilla.id)]      
    ]
    logger.debug(dias_citas)        
    relacion = []
    relaciones_agenda = RelacionAgendaPlantilla.where(agenda_id:@agenda.id).distinct.pluck(:dia,:dia_nombre)             
    logger.debug("******** relaicon agenda ******** #{relaciones_agenda}")
    dias_citas.each do |dia|
      logger.debug("******** dia ******** #{dia}")
      citas_creadas = Cita.where(agenda_id: @agenda.id).joins(:relacion_agenda_plantilla).where(relacion_agenda_plantillas: { dia_nombre: dia[0]})      
      if citas_creadas.count  ==  dia[1] # || dia[0]=="VIERNES"
        logger.debug("******** ENTRO")
        relacion = relaciones_agenda.delete_if  {|rel| rel[1]==dia[0]} 
        logger.debug("******** relacion ******** #{relacion}")
        
      else
        relacion = relaciones_agenda
      end
    end
    logger.debug("******** relacion ******** #{relacion}")
    #@relaciones_agenda = RelacionAgendaPlantilla.where(agenda_id:@agenda.id)    
    #@relaciones_disponibles
    respond_to do |format|
      format.turbo_stream { render partial: "citas/cargar_dia", 
      locals: { relaciones: relacion,agenda:@agenda}}
    end
  end
  def setHorarioDisponibles
    dia=params[:dias].split("_")[0]
    numero_dia = params[:dias].split("_")[1]
    paciente = params[:paciente] == 'Perro' ? 'C' : 'F'
    sexo = params[:sexo] == 'Hembra' ? 'H' : 'M'
    citas_posibles = []
    relacion = RelacionAgendaPlantilla.where(agenda:params[:agenda_id],dia_nombre:dia)    
    relacion.each do |rel|   
      mesa = rel.detalle_plantilla.mesa_id
      detalle_mesa = DetalleMesa.where(paciente: paciente,sexo: sexo,mesa_id: mesa)            
      detalle_mesa.each do |dm|
        citas_posibles.push(dm.id)          
      end      
    end
    logger.debug("*************** citas_posibles #{citas_posibles}")
    citas_disponibles = []
    citas_creadas = Cita.where(agenda_id:params[:agenda])
    if citas_creadas.count == 0
      citas_disponibles = citas_posibles
    else    
      citas_creadas.each do |cita|
        logger.debug "******************"+cita.detalle_mesa_id
        if !citas_posibles.include?(cita.detalle_mesa_id)
          citas_disponibles.push(cita.detalle_mesa_id)
        end
      end
    end
    logger.debug("*************** citas_disponibles #{citas_disponibles}")
    @horarios = DetalleMesa.where("id in (?)",citas_disponibles)    
    respond_to do |format|
      format.turbo_stream { render partial: "citas/cargar_horarios", 
      locals: { horarios: @horarios}}
    end
  end
  # PATCH/PUT /citas/1 or /citas/1.json
  def update
    respond_to do |format|
      if @cita.update(cita_params)
        format.html { redirect_to @cita, notice: "Cita was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @cita }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @cita.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /citas/1 or /citas/1.json
  def destroy
    @cita.destroy!

    respond_to do |format|
      format.html { redirect_to citas_path, notice: "Cita was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def cargar_catalogos
      @relaciones_agenda = RelacionAgendaPlantilla.all
      @detalles_mesa = DetalleMesa.all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_cita
      @cita = Cita.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cita_params
      params.require(:cita).permit(:estado, :nombre_dueño, :especie, :sexo, :telefono, :motivo, :fecha, :edad_dueño, :calle, :colonia, :localidad, :municipio, :vacuna, :nombre_mascota, :edad_mascota, :raza, :medico, :curp, :sexo_dueño, :apellido_p_dueño, :apellido_m_dueño, :relacion_agenda_plantilla_id, :detalle_mesa_id)
    end
end
