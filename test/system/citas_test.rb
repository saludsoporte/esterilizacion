require "application_system_test_case"

class CitasTest < ApplicationSystemTestCase
  setup do
    @cita = citas(:one)
  end

  test "visiting the index" do
    visit citas_url
    assert_selector "h1", text: "Citas"
  end

  test "should create cita" do
    visit citas_url
    click_on "New cita"

    fill_in "Apellido m dueño", with: @cita.apellido_m_dueño
    fill_in "Apellido p dueño", with: @cita.apellido_p_dueño
    fill_in "Calle", with: @cita.calle
    fill_in "Colonia", with: @cita.colonia
    fill_in "Curp", with: @cita.curp
    fill_in "Detalle mesa", with: @cita.detalle_mesa_id
    fill_in "Edad dueño", with: @cita.edad_dueño
    fill_in "Edad mascota", with: @cita.edad_mascota
    fill_in "Especie", with: @cita.especie
    fill_in "Estado", with: @cita.estado
    fill_in "Fecha", with: @cita.fecha
    fill_in "Localidad", with: @cita.localidad
    fill_in "Medico", with: @cita.medico
    fill_in "Motivo", with: @cita.motivo
    fill_in "Municipio", with: @cita.municipio
    fill_in "Nombre dueño", with: @cita.nombre_dueño
    fill_in "Nombre mascota", with: @cita.nombre_mascota
    fill_in "Raza", with: @cita.raza
    fill_in "Relacion agenda plantilla", with: @cita.relacion_agenda_plantilla_id
    fill_in "Sexo", with: @cita.sexo
    fill_in "Sexo dueño", with: @cita.sexo_dueño
    fill_in "Telefono", with: @cita.telefono
    check "Vacuna" if @cita.vacuna
    click_on "Create Cita"

    assert_text "Cita was successfully created"
    click_on "Back"
  end

  test "should update Cita" do
    visit cita_url(@cita)
    click_on "Edit this cita", match: :first

    fill_in "Apellido m dueño", with: @cita.apellido_m_dueño
    fill_in "Apellido p dueño", with: @cita.apellido_p_dueño
    fill_in "Calle", with: @cita.calle
    fill_in "Colonia", with: @cita.colonia
    fill_in "Curp", with: @cita.curp
    fill_in "Detalle mesa", with: @cita.detalle_mesa_id
    fill_in "Edad dueño", with: @cita.edad_dueño
    fill_in "Edad mascota", with: @cita.edad_mascota
    fill_in "Especie", with: @cita.especie
    fill_in "Estado", with: @cita.estado
    fill_in "Fecha", with: @cita.fecha
    fill_in "Localidad", with: @cita.localidad
    fill_in "Medico", with: @cita.medico
    fill_in "Motivo", with: @cita.motivo
    fill_in "Municipio", with: @cita.municipio
    fill_in "Nombre dueño", with: @cita.nombre_dueño
    fill_in "Nombre mascota", with: @cita.nombre_mascota
    fill_in "Raza", with: @cita.raza
    fill_in "Relacion agenda plantilla", with: @cita.relacion_agenda_plantilla_id
    fill_in "Sexo", with: @cita.sexo
    fill_in "Sexo dueño", with: @cita.sexo_dueño
    fill_in "Telefono", with: @cita.telefono
    check "Vacuna" if @cita.vacuna
    click_on "Update Cita"

    assert_text "Cita was successfully updated"
    click_on "Back"
  end

  test "should destroy Cita" do
    visit cita_url(@cita)
    click_on "Destroy this cita", match: :first

    assert_text "Cita was successfully destroyed"
  end
end
