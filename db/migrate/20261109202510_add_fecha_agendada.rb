class AddFechaAgendada < ActiveRecord::Migration[7.1]
  def change
    add_column :relacion_agenda_plantillas, :fecha_agendada, :date
  end
end
