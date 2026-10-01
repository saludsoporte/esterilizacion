class AgendasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_agenda, only: [:show, :edit, :update, :destroy]

  include Pagy::Backend
  # GET /agendas or /agendas.json
  def index
    @pagy,@agendas = pagy(Agenda.all)
    Agenda.where(activo: true)
      .where("fecha_fin < ?", Time.current)
      .update_all(activo: false)    
  end

  # GET /agendas/1 or /agendas/1.json
  def show
    @agenda = Agenda.find(params[:id])
  end

  # GET /agendas/new
  def new
    @agenda = Agenda.new
  end

  def atender_cita        
    cita = Cita.find(params[:cita_id])

    cita.update!(estado: "ATENDIENDO")

    redirect_to agenda_path(cita.agenda_id)
  end
  def cancelar_cita        
    cita = Cita.find(params[:cita_id])
    cita.update!(estado: "CANCELADA")
    #preguntar si se quiere enviar correo de cancelacion
    redirect_to agenda_path(cita.agenda_id)
  end
  # GET /agendas/1/edit
  def edit
    agenda = Agenda.find(params[:id])
    @medicos = User.all
  end

  # POST /agendas or /agendas.json
  def create
    @agenda = Agenda.new(agenda_params)
    @agenda.hora_inicio = '8:00'
    respond_to do |format|
      if @agenda.save
        agenda = Agenda.last
        format.html { redirect_to new_relacion_agenda_plantilla_path(agenda:agenda.id), notice: "Agenda was successfully created." }
        format.json { render :show, status: :created, location: @agenda }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @agenda.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /agendas/1 or /agendas/1.json
  def update
    respond_to do |format|
      if @agenda.update(agenda_params)
        format.html { redirect_to @agenda, notice: "Agenda was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @agenda }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @agenda.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /agendas/1 or /agendas/1.json
  def destroy
    @agenda.destroy!

    respond_to do |format|
      format.html { redirect_to agendas_path, notice: "Agenda was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agenda
      Rails.logger.debug "🔥 SET_AGENDA EJECUTADO"
  Rails.logger.debug "🔥 ACTION: #{action_name}"
  Rails.logger.debug "🔥 PARAMS: #{params.inspect}"

      @agenda = Agenda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agenda_params
      params.require(:agenda).permit(:fecha_inicio, :fecha_fin,:activo,:user_id)
    end
end
