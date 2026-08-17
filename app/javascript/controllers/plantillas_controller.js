import { Controller } from "@hotwired/stimulus"

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
}
