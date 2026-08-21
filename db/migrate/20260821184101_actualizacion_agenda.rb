class ActualizacionAgenda < ActiveRecord::Migration[7.1]
  def change
    rename_column :agendas, :fecha, :fecha_inicio
    add_column :agendas, :fecha_fin, :date
    rename_column :agendas, :citas, :num_citas
    add_reference :agendas, :user, null: false, foreign_key: true
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    remove_column :agendas, :medico
  end
end
