class CreateDetallePlantillas < ActiveRecord::Migration[7.1]
  def change
    create_table :detalle_plantillas do |t|
      t.string :dia
      t.references :mesa, null: false, foreign_key: true
      t.references :plantilla, null: false, foreign_key: true      
      t.timestamps
    end
  end
end
