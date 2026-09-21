import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
// Connects to data-controller="citas"
export default class extends Controller {
  connect() {
    $("#cita_sexo").on("change", function () {
      if ($(this).val() != "") {
        if ($("#cita_especie").val() != null) {
          ajaxTurbo("setDiasDisponibles",{});
        }
      }
    });
     $(document).on("change", "#dias", function () {
       if ($(this).val() != null) {
         ajaxTurbo("setHorarioDisponibles", {});
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
