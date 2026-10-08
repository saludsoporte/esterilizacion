class CitasController < ApplicationController
  before_action :set_cita, only: %i[ show edit update destroy ]
  before_action :cargar_catalogos, only: %i[new edit]
  
  def atender_cita        
    cita = Cita.find(params[:cita_id])       
    cambiar_estado_cita( cita, "ATENDIENDO", "La cita de #{cita.nombre_mascota} ha comenzado a ser atendida.", "La cita está siendo atendida." )    
  end
  def finalizar_cita     
    cita = Cita.find(params[:cita_id]) 
    cita.update(estado: "FINALIZADA") 
    cambiar_estado_cita( cita, "FINALIZADA", "La cita de #{cita.nombre_mascota} ha finalizado.", "La cita termino." )    
  end  
  def cancelar_cita        
    cita = Cita.find(params[:cita_id])
    cambiar_estado_cita( cita, "CANCELADA", "La cita de #{cita.nombre_mascota} ha sido cancelada.", "La cita ha sido cancelada." )    
    #preguntar si se quiere enviar correo de cancelacion
    
  end
  def cambiar_estado_cita(cita, estado, mensaje, notice) 
    if cita.update(estado: estado)   
      actualizar_notificacion_cita(cita, mensaje) 
    else
      flash[:alert] = "No se pudo actualizar el estado de la cita."
    end
    redirect_to mis_citas_path
  end
  def actualizar_notificacion_cita(cita, mensaje)     
    medico = cita.relacion_agenda_plantilla.user 
    notificacion = Notificacion.find_or_initialize_by( user: medico, cita: cita )     
    notificacion.mensaje = mensaje
    notificacion.leida = false 
    notificacion.save! 
  end

  def mis_citas
    @citas = Cita.where(relacion_agenda_plantilla: RelacionAgendaPlantilla.where(user: current_user))
  end

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
    #buscar la relacion con la mesa el dia y la plantilla     
    if params[:dia_disponible].nil? == false && params[:detalle_mesa_id].nil? == false
      agenda = Agenda.find(params[:agenda_id])
      dia= params[:dia_disponible].split('_')[0]
      dia_numero = params[:dia_disponible].split('_')[1]
      detalle_mesa = DetalleMesa.find(params[:detalle_mesa_id])  
      det_plantilla = DetallePlantilla.find_by(dia:dia,mesa:detalle_mesa.mesa_id,plantilla:agenda.plantilla)
      relacion = RelacionAgendaPlantilla.find_by(detalle_plantilla_id:det_plantilla.id,dia_nombre:dia,dia:dia_numero)    
      params[:cita][:estado]= "PENDIENTE"
      params[:cita][:relacion_agenda_plantilla_id] = relacion.id
      params[:cita][:detalle_mesa_id]=detalle_mesa.id
      params[:cita][:agenda_id]=agenda.id
      params[:cita][:medico]=relacion.user.nombre
      params[:cita][:fecha]=Time.now()
    end
    
    @cita = Cita.new(cita_params)
    respond_to do |format|
      if @cita.save
        citas = Cita.where(agenda_id: @cita.agenda_id)
        @cita.agenda.update(num_citas:citas.count)        
        Notificacion.create!(
          user: @cita.relacion_agenda_plantilla.user,
          cita: @cita,
          mensaje: "La cita de #{@cita.nombre_mascota} esta pendiente.",
          leida: false
        )
        CitaMailer.with(cita: @cita).confirmacion.deliver_later
        flash[:notice] = "Cita creada exitosamente. Se ha enviado un correo de confirmación a #{@cita.email}."
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
    if @agenda.nil? == false && @agenda.relacion_agenda_plantillas.exists? == true
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
    end
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
      params.require(:cita).permit(:email,:estado, :nombre_dueño, :especie, :sexo, :telefono, :motivo, :fecha, :edad_dueño, :calle, :colonia, :localidad, :municipio, :vacuna, :nombre_mascota, :edad_mascota, :raza, :medico, :curp, :sexo_dueño, :apellido_p_dueño, :apellido_m_dueño, :relacion_agenda_plantilla_id, :detalle_mesa_id,:agenda_id)
    end
end
