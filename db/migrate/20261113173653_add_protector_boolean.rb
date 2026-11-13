class AddProtectorBoolean < ActiveRecord::Migration[7.1]
  def change
    add_column :detalle_mesas, :protector, :boolean, default: false
  end
end
