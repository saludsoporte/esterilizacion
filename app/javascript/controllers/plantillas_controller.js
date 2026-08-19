import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
//import "jquery_ujs";
//import "popper";
import "select2";
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
  eliminarMesa(event) {
    const boton = event.currentTarget;
    const mesaId = boton.dataset.mesaId;

    if (!confirm("¿Estás seguro de eliminar esta mesa?")) {
      return;
    }

    fetch(`/mesas/${mesaId}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Error al eliminar la mesa");
        }

        return response.text();
      })
      .then((html) => {
        Turbo.renderStreamMessage(html);
      })
      .catch((error) => {
        console.error(error);
        alert("No se pudo eliminar la mesa.");
      });
  }
}
