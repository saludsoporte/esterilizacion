class CreateMesas < ActiveRecord::Migration[7.1]
  def change
    create_table :mesas do |t|
      t.string :nombre_mesa

      t.timestamps
    end
  end
end
