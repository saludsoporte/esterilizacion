class Agenda < ApplicationRecord
  validates :fecha_inicio, :fecha_fin , presence: true
end
