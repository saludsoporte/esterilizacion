import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
// Connects to data-controller="relacion"
export default class extends Controller {
  connect() {
    console.log("relacion_controller.js conectado");
    $("#dias").on("change", function () {
       ajaxTurbo("setMesa", {
         user_id: $("#user_id").val(),
         agenda_id: $("#agenda_id").val(),
         plantilla_id: $("#plantilla_id").val(),
         dia: $(this).val()
       });
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