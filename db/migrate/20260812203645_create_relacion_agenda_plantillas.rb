class CreateRelacionAgendaPlantillas < ActiveRecord::Migration[7.1]
  def change
    create_table :relacion_agenda_plantillas do |t|
      t.references :agenda, null: false, foreign_key: true
      t.references :plantilla, null: false, foreign_key: true

      t.timestamps
    end
  end
end
