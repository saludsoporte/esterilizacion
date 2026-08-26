import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

// Connects to data-controller="agenda"
export default class extends Controller {
  connect() {
    iniciarSemana();
  }
}
function iniciarSemana() {
  const hoy = new Date();
  const diaActual = hoy.getDay();
  const diasHastaLunes = diaActual === 0 ? 1 : 8 - diaActual;
  const proximoLunes = new Date(hoy);
  proximoLunes.setDate(hoy.getDate() + diasHastaLunes);
  const proximoViernes = new Date(proximoLunes)
  proximoViernes.setDate(proximoLunes.getDate() + 4);
  console.log(proximoLunes.toISOString().split('T')[0])
  console.log(proximoViernes.toISOString().split("T")[0]);
  $("#agenda_fecha_inicio").val(proximoLunes.toISOString().split('T')[0])
  $("#agenda_fecha_fin").val(proximoViernes.toISOString().split("T")[0]);
}