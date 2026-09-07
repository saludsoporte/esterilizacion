class RelacionAgendaPlantilla < ApplicationRecord
  belongs_to :agenda
  belongs_to :plantilla
  belongs_to :user
  belongs_to :detalle_plantilla
end
