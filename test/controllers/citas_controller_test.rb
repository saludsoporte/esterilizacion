require "test_helper"

class CitasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cita = citas(:one)
  end

  test "should get index" do
    get citas_url
    assert_response :success
  end

  test "should get new" do
    get new_cita_url
    assert_response :success
  end

  test "should create cita" do
    assert_difference("Cita.count") do
      post citas_url, params: { cita: { apellido_m_dueño: @cita.apellido_m_dueño, apellido_p_dueño: @cita.apellido_p_dueño, calle: @cita.calle, colonia: @cita.colonia, curp: @cita.curp, detalle_mesa_id: @cita.detalle_mesa_id, edad_dueño: @cita.edad_dueño, edad_mascota: @cita.edad_mascota, especie: @cita.especie, estado: @cita.estado, fecha: @cita.fecha, localidad: @cita.localidad, medico: @cita.medico, motivo: @cita.motivo, municipio: @cita.municipio, nombre_dueño: @cita.nombre_dueño, nombre_mascota: @cita.nombre_mascota, raza: @cita.raza, relacion_agenda_plantilla_id: @cita.relacion_agenda_plantilla_id, sexo: @cita.sexo, sexo_dueño: @cita.sexo_dueño, telefono: @cita.telefono, vacuna: @cita.vacuna } }
    end

    assert_redirected_to cita_url(Cita.last)
  end

  test "should show cita" do
    get cita_url(@cita)
    assert_response :success
  end

  test "should get edit" do
    get edit_cita_url(@cita)
    assert_response :success
  end

  test "should update cita" do
    patch cita_url(@cita), params: { cita: { apellido_m_dueño: @cita.apellido_m_dueño, apellido_p_dueño: @cita.apellido_p_dueño, calle: @cita.calle, colonia: @cita.colonia, curp: @cita.curp, detalle_mesa_id: @cita.detalle_mesa_id, edad_dueño: @cita.edad_dueño, edad_mascota: @cita.edad_mascota, especie: @cita.especie, estado: @cita.estado, fecha: @cita.fecha, localidad: @cita.localidad, medico: @cita.medico, motivo: @cita.motivo, municipio: @cita.municipio, nombre_dueño: @cita.nombre_dueño, nombre_mascota: @cita.nombre_mascota, raza: @cita.raza, relacion_agenda_plantilla_id: @cita.relacion_agenda_plantilla_id, sexo: @cita.sexo, sexo_dueño: @cita.sexo_dueño, telefono: @cita.telefono, vacuna: @cita.vacuna } }
    assert_redirected_to cita_url(@cita)
  end

  test "should destroy cita" do
    assert_difference("Cita.count", -1) do
      delete cita_url(@cita)
    end

    assert_redirected_to citas_url
  end
end
