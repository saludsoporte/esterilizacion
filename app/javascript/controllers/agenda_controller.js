import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

// Connects to data-controller="agenda"
export default class extends Controller {
  connect() {
    console.log("se conecto a agenda")
    //iniciarSemana();
    $("#plantilla_id").val(null).trigger('change')
    $("#plantilla_id").on('change',function(){      
      if(valId != null){
        ajaxTurbo("setDiasMeses", { agenda_id:$("#agenda_id").val(), plantilla_id:$(this).val() });
      }      
    })
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