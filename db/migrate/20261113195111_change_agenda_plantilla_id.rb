class ChangeAgendaPlantillaId < ActiveRecord::Migration[7.1]
  def change
    remove_column :detalle_extras, :agenda_id, :bigint
    add_reference :detalle_extras, :plantilla, foreign_key: true
    remove_column :detalle_mesas, :protector, :boolean
  end
end
