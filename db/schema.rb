# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_09_22_205306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendas", force: :cascade do |t|
    t.date "fecha_inicio"
    t.integer "num_citas"
    t.time "hora_inicio"
    t.boolean "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_fin"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_agendas_on_user_id"
  end

  create_table "citas", force: :cascade do |t|
    t.string "estado"
    t.string "nombre_dueño"
    t.string "especie"
    t.string "sexo"
    t.string "telefono"
    t.string "motivo"
    t.date "fecha"
    t.integer "edad_dueño"
    t.string "calle"
    t.string "colonia"
    t.string "localidad"
    t.string "municipio"
    t.boolean "vacuna"
    t.string "nombre_mascota"
    t.string "edad_mascota"
    t.string "raza"
    t.string "medico"
    t.string "curp"
    t.string "sexo_dueño"
    t.string "apellido_p_dueño"
    t.string "apellido_m_dueño"
    t.bigint "relacion_agenda_plantilla_id", null: false
    t.bigint "detalle_mesa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.bigint "agenda_id", null: false
    t.index ["agenda_id"], name: "index_citas_on_agenda_id"
    t.index ["detalle_mesa_id"], name: "index_citas_on_detalle_mesa_id"
    t.index ["relacion_agenda_plantilla_id"], name: "index_citas_on_relacion_agenda_plantilla_id"
  end

  create_table "detalle_extras", force: :cascade do |t|
    t.string "paciente"
    t.string "sexo"
    t.time "horario"
    t.bigint "mesa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agenda_id", null: false
    t.index ["agenda_id"], name: "index_detalle_extras_on_agenda_id"
    t.index ["mesa_id"], name: "index_detalle_extras_on_mesa_id"
  end

  create_table "detalle_mesas", force: :cascade do |t|
    t.string "paciente"
    t.string "sexo"
    t.time "horario"
    t.bigint "mesa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mesa_id"], name: "index_detalle_mesas_on_mesa_id"
  end

  create_table "detalle_plantillas", force: :cascade do |t|
    t.string "dia"
    t.bigint "mesa_id", null: false
    t.bigint "plantilla_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mesa_id"], name: "index_detalle_plantillas_on_mesa_id"
    t.index ["plantilla_id"], name: "index_detalle_plantillas_on_plantilla_id"
  end

  create_table "mesas", force: :cascade do |t|
    t.string "nombre_mesa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "seleccionada", default: false
  end

  create_table "plantillas", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relacion_agenda_plantillas", force: :cascade do |t|
    t.bigint "agenda_id", null: false
    t.bigint "plantilla_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "detalle_plantilla_id", null: false
    t.bigint "user_id", null: false
    t.bigint "detalle_extra_id"
    t.integer "dia"
    t.string "dia_nombre"
    t.index ["agenda_id"], name: "index_relacion_agenda_plantillas_on_agenda_id"
    t.index ["detalle_extra_id"], name: "index_relacion_agenda_plantillas_on_detalle_extra_id"
    t.index ["detalle_plantilla_id"], name: "index_relacion_agenda_plantillas_on_detalle_plantilla_id"
    t.index ["plantilla_id"], name: "index_relacion_agenda_plantillas_on_plantilla_id"
    t.index ["user_id"], name: "index_relacion_agenda_plantillas_on_user_id"
  end

  create_table "rols", force: :cascade do |t|
    t.string "rol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre"
    t.string "apellido_p"
    t.string "apellido_m"
    t.bigint "rols_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rols_id"], name: "index_users_on_rols_id"
  end

  add_foreign_key "agendas", "users"
  add_foreign_key "citas", "agendas"
  add_foreign_key "citas", "detalle_mesas"
  add_foreign_key "citas", "relacion_agenda_plantillas"
  add_foreign_key "detalle_extras", "agendas"
  add_foreign_key "detalle_extras", "mesas"
  add_foreign_key "detalle_mesas", "mesas"
  add_foreign_key "detalle_plantillas", "mesas"
  add_foreign_key "detalle_plantillas", "plantillas"
  add_foreign_key "relacion_agenda_plantillas", "agendas"
  add_foreign_key "relacion_agenda_plantillas", "detalle_extras"
  add_foreign_key "relacion_agenda_plantillas", "detalle_plantillas"
  add_foreign_key "relacion_agenda_plantillas", "plantillas"
  add_foreign_key "relacion_agenda_plantillas", "users"
  add_foreign_key "users", "rols", column: "rols_id"
end
