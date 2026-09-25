class Cita < ApplicationRecord
  belongs_to :relacion_agenda_plantilla
  belongs_to :detalle_mesa

  def sexo_definido
    self[:sexo_dueño] == 'M' ? 'Masculino' : 'Femenino'
  end
end
