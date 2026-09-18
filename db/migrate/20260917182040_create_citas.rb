class CreateCitas < ActiveRecord::Migration[7.1]
  def change
    create_table :citas do |t|
      t.string :estado
      t.string :nombre_dueño
      t.string :especie
      t.string :sexo
      t.string :telefono
      t.string :motivo
      t.date :fecha
      t.integer :edad_dueño
      t.string :calle
      t.string :colonia
      t.string :localidad
      t.string :municipio
      t.boolean :vacuna
      t.string :nombre_mascota
      t.string :edad_mascota
      t.string :raza
      t.string :medico
      t.string :curp
      t.string :sexo_dueño
      t.string :apellido_p_dueño
      t.string :apellido_m_dueño
      t.references :relacion_agenda_plantilla, null: false, foreign_key: true
      t.references :detalle_mesa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
