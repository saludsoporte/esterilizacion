class RelacionAgendaPlantilla < ApplicationRecord
  belongs_to :agenda
  belongs_to :plantilla
end
