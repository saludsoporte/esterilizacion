class Plantilla < ApplicationRecord
  has_many :detalle_plantillas, dependent: :destroy
  has_many :agendas
end
