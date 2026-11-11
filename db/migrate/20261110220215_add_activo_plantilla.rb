class AddActivoPlantilla < ActiveRecord::Migration[7.1]
  def change
    add_column :plantillas, :activo, :boolean, default: false
  end
end
