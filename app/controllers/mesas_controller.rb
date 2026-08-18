class MesasController < ApplicationController
  def new    
    @mesa=Mesa.new
    @mesas = Mesa.all
    #@mesa.detalle_mesas.build
  end
  def agregar_detalle    
    @mesa = Mesa.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end
  def create    
    @mesa=Mesa.new(nombre_mesa:params[:mesa][:nombre])
    if @mesa.save      
      params[:mesa][:detalle_mesas_attributes].each do |indice, detalle|
        tipo = detalle[:tipo].split("_")
        paciente = tipo[0]
        sexo = tipo[1]
        horario = detalle[:horario]
        detalle_mesa = DetalleMesa.new(paciente: paciente, sexo: sexo,horario: horario, mesa_id: @mesa.id)
        detalle_mesa.save
      end
    end          
  end

  def destroy
    @mesa = Mesa.find(params[:id])
    @mesa.destroy
    @mesas = Mesa.includes(:detalle_mesas).order(:id)
    respond_to do |format|
    format.turbo_stream

    format.html do
      redirect_to mesas_lista_path,
                  notice: "Mesa eliminada correctamente."
    end 
  end  
  end
end
