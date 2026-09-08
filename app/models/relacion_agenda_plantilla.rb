class RelacionAgendaPlantilla < ApplicationRecord
  belongs_to :agenda
  belongs_to :plantilla
  belongs_to :user
  belongs_to :detalle_plantilla

  def horarios    
    detalle = DetallePlantilla.find(self.detalle_plantilla_id)
    horarios = detalle.mesa.detalle_mesas.map { |detalle_mesa| detalle_mesa.detalle_hora } 
    return horarios 
  end  
end
