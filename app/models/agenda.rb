class Agenda < ApplicationRecord
  belongs_to :user  
  has_many :relacion_agenda_plantillas 
  validates :fecha_inicio, :fecha_fin , presence: true
  def plantilla
    relacion_agenda_plantillas.first&.plantilla
  end
end
