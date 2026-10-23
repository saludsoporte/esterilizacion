class AddPlantillaToDetalleMesas < ActiveRecord::Migration[7.1]
  def change
    add_reference :detalle_mesas, :plantilla, null: true, foreign_key: true
  end
end
