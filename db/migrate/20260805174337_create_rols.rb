class CreateRols < ActiveRecord::Migration[7.1]
  def change
    create_table :rols do |t|
      t.string :rol

      t.timestamps
    end
  end
end
