class AddDiaProtector < ActiveRecord::Migration[7.1]
  def change
    add_column :plantillas, :dia_protector, :string
  end
end
