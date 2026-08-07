class AtributosUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nombre, :string
    add_column :users, :apellido_p, :string
    add_column :users, :apellido_m, :string
    add_reference :users, :rols, foreign_key: true
  end
end
