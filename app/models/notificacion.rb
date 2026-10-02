class Notificacion < ApplicationRecord
  belongs_to :user
  belongs_to :cita, optional: true

  scope :no_leidas, -> { where(leida: false) }
end
