class DetallePlantilla < ApplicationRecord
  belongs_to :mesa
  belongs_to :plantilla
  has_many :relacion_agenda_plantillas
end
