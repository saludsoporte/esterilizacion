import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

// Connects to data-controller="plantillas"
export default class extends Controller {
  static targets = [
    "contenedor",
    "template",
    "page",
    "stepIndicator",
    "button",
    "detalles",
    "template",
    "mesa",
    "mesasSeleccionadas",
  ];
  connect() {
    console.log("plantillas CONTROLLER CONECTADO");
    this.currentStep = 0;
    this.mostrarPaso();
  }
  cambiar() {
    $("#sbmBtn").prop("disabled", false);
  }
  cerrar() {
    $("#modal").empty();
  }
  siguiente() {    
    if (this.currentStep === 1) {      
      this.cargarMesasSeleccionadas();
    }
    if (this.currentStep < this.pageTargets.length - 1) {
      this.currentStep++;
      this.mostrarPaso();
    }
  }

  anterior() {
    if (this.currentStep > 0) {
      this.currentStep--;
      this.mostrarPaso();
    }
  }

  mostrarPaso() {
    this.pageTargets.forEach((page, index) => {
      page.classList.toggle("active", index === this.currentStep);
    });
    this.stepIndicatorTargets.forEach((step, index) => {
      step.classList.toggle("active", index === this.currentStep);
      step.classList.toggle("completed", index < this.currentStep);
    });
  }

  seleccionarMesa(event) {
    const checkbox = event.currentTarget;
    const mesaId = checkbox.value;
    const seleccionada = checkbox.checked;
    fetch(`/mesas/${mesaId}/seleccionar`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
        "Content-Type": "application/json",
        Accept: "text/vnd.turbo-stream.html",
      },
      body: JSON.stringify({
        seleccionada: seleccionada,
      }),
    });
  }
  cargarMesasSeleccionadas() {
    const frame = document.getElementById("mesas_seleccionadas");

    frame.src = frame.dataset.url;
  }
}
