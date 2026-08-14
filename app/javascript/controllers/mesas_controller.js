import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [
    "contenedor",
    "template",
    "page",
    "stepIndicator",
    "caja",
    "valor",
  ];
  static values = {
    fh: String,
    fm: String,
  };
  connect() {
    this.currentStep = 0;
    this.mostrarPaso();
    console.log(this.valorTarget);
    this.actualizar();
  }
  cambiar() {
    this.actualizar();
  }
  actualizar() {
    if (this.cajaTarget.checked) {
      this.valorTarget.value = this.fmValue;
    } else {
      this.valorTarget.value = this.fhValue;
    }
  }
  cerrar() {
    console.log("Cerrando modal");
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
    console.log(" Step:", this.stepIndicatorTargets);
    this.stepIndicatorTargets.forEach((step, index) => {
      console.log("Current Step:", this.currentStep, "Index:", index);
      step.classList.toggle("active", index === this.currentStep);
      step.classList.toggle("completed", index < this.currentStep);
    });
  }
}
