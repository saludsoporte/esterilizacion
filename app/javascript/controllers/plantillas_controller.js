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
    if (this.currentStep < this.pageTargets.length - 1) {
      this.currentStep++;
      this.mostrarPaso();      
      if (this.currentStep == 2) {
       this.mostrarMesasSeleccionadas();
      }
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
  mostrarMesasSeleccionadas() {
    const seleccionadas = this.mesaTargets.filter((mesa) => mesa.checked);

    this.mesasSeleccionadasTarget.innerHTML = "";

    if (seleccionadas.length === 0) {
      this.mesasSeleccionadasTarget.innerHTML = `
        <div class="alert alert-warning">
          No has seleccionado ninguna mesa.
        </div>
      `;

      return;
    }
    seleccionadas.forEach((mesa) => {
      const div = document.createElement("div");
      const nombre = mesa.dataset.nombre;
      div.classList.add("mesa-seleccionada", "card", "mb-2");

      div.innerHTML = `
        <div class="card-body">
          <i class="bi bi-grid-3x3-gap-fill"></i>
          Mesa ${nombre}
        </div>
      `;

      this.mesasSeleccionadasTarget.appendChild(div);
    });
  }
}
