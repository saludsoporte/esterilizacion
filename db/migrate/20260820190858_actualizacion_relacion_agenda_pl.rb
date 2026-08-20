class ActualizacionRelacionAgendaPl < ActiveRecord::Migration[7.1]
  def change
    add_reference :relacion_agenda_plantillas, :detalle_plantilla, null: false, foreign_key: true
    add_reference :relacion_agenda_plantillas, :user, null: false, foreign_key: true
    add_reference :relacion_agenda_plantillas, :detalle_extra, null: true, foreign_key: true
  end
end
