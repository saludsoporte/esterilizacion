class AddReferencias < ActiveRecord::Migration[7.1]
  def change
    add_reference :plantillas, :detalle_extra, null: true, foreign_key: true
    add_reference :plantillas, :agenda, null: true, foreign_key: true
    add_reference :detalle_extras, :agenda, null: false, foreign_key: true
  end
end
