import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [
    "contenedor",
    "template",
    "page",
    "stepIndicator",
    "button",
    "detalles",
    "template",
    "horario",
  ];
  connect() {
    console.log("MESAS CONTROLLER CONECTADO");
    this.index2 = 0;
  }

  agregarDetalle() {
    console.log("Índice actual:", this.index2);

    let html = this.templateTarget.innerHTML;

    html = html.replaceAll("INDEX", this.index2);

    //console.log("HTML generado:", html);

    this.detallesTarget.insertAdjacentHTML("beforeend", html);

    this.index2++;
  }
  cambiarHorario() {
    this.actualizarHorarios();
  }

  actualizarHorarios() {
    const seleccionados = this.horarioTargets
      .map((select) => select.value)
      .filter((value) => value !== "");

    this.horarioTargets.forEach((select) => {
      Array.from(select.options).forEach((option) => {
        if (option.value === "") return;

        option.disabled =
          seleccionados.includes(option.value) && option.value !== select.value;
      });
    });
  }
}
