class CreateDetalleMesas < ActiveRecord::Migration[7.1]
  def change
    create_table :detalle_mesas do |t|
      t.string :paciente
      t.string :sexo
      t.time :horario
      t.references :mesa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
