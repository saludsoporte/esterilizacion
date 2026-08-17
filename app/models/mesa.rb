class Mesa < ApplicationRecord
   has_many :detalle_mesas, dependent: :destroy

  accepts_nested_attributes_for :detalle_mesas,
                                allow_destroy: true
end
