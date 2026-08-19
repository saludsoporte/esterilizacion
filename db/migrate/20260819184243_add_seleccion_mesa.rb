class AddSeleccionMesa < ActiveRecord::Migration[7.1]
  def change
    add_column :mesas, :seleccionada, :boolean, default: false
  end
end
