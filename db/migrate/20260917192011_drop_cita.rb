class DropCita < ActiveRecord::Migration[7.1]
  def change
     drop_table :cita
  end
end
