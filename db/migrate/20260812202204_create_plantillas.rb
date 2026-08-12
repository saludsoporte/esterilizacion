class CreatePlantillas < ActiveRecord::Migration[7.1]
  def change
    create_table :plantillas do |t|
      t.string :nombre
      t.string :dia
      t.references :mesa, null: false, foreign_key: true
      #t.references :detalle_extra, null: true, foreign_key: true
      #t.references :agenda, null: true, foreign_key: true
      t.timestamps
    end
  end
end
