class Agenda < ApplicationRecord
  belongs_to :user  
  validates :fecha_inicio, :fecha_fin , presence: true
end
