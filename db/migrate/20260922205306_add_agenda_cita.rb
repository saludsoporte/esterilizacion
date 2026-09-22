class AddAgendaCita < ActiveRecord::Migration[7.1]
  def change
    add_reference :citas, :agenda, null: false, foreign_key: true
  end
end
