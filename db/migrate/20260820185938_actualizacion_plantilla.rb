class ActualizacionPlantilla < ActiveRecord::Migration[7.1]
  def change
    #remove_reference :plantillas, :detalle_extra, null: false, foreign_key: true
    #remove_reference :plantillas, :mesa, null: false, foreign_key: true
    #remove_reference :plantillas, :agenda,null:false,foreign_key: true
    remove_column :plantillas, :dia, :string

  end
end
