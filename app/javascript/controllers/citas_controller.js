import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
// Connects to data-controller="citas"
export default class extends Controller {
  connect() {
    $("#cita_sexo").on("change", function () {
      if ($(this).val() != "") {
        if ($("#cita_especie").val() != null) {
          ajaxTurbo("setDiasDisponibles", {
            paciente: $("#cita_especie").val(),
            sexo: $("#cita_sexo").val(),
          });
        }
      }
    });
     $(document).on("change", "#dia_disponible", function () {
       if ($(this).val() != null) {
         ajaxTurbo("setHorarioDisponibles", {agenda_id:$("#agenda_id").val(),dias:$(this).val(),paciente:$("#cita_especie").val(),sexo:$("#cita_sexo").val()});
       }
     });    
  }
}
function ajaxTurbo(ruta, parametros) {
  const csrtToken = document.querySelector("meta[name='csrf-token']").content;
  fetch(ruta, {
    method: "POST",
    mode: "cors",
    cache: "no-cache",
    credentials: "same-origin",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrtToken,
    },
    body: JSON.stringify(parametros),
  })
    .then((response) => response.text())
    .then(Turbo.renderStreamMessage);
}
