class Cita < ApplicationRecord
  belongs_to :relacion_agenda_plantilla
  belongs_to :detalle_mesa
end
