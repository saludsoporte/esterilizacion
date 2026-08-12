class CreateAgendas < ActiveRecord::Migration[7.1]
  def change
    create_table :agendas do |t|
      t.date :fecha
      t.string :medico
      t.integer :citas
      t.time :hora_inicio
      t.boolean :activo

      t.timestamps
    end
  end
end
