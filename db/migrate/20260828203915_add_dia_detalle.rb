class AddDiaDetalle < ActiveRecord::Migration[7.1]
  def change
    add_column :relacion_agenda_plantillas, :dia, :integer
    add_column :relacion_agenda_plantillas, :dia_nombre, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
