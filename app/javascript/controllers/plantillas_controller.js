import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
//import "jquery_ujs";
//import "popper";
import "select2";
// Connects to data-controller="plantillas"
export default class extends Controller {
  static targets = [
    "contenedor",
    "page",
    "stepIndicator",
    "button",
    "detalles",
    "template",
    "horario",
    "mesa",
    "mesasSeleccionadas",
  ];
  connect() {
    console.log("plantillas CONTROLLER CONECTADO");
    this.currentStep = 0;
    this.mostrarPaso();
    this.index2 = 0;
  }
  cambiar() {
    $("#sbmBtn").prop("disabled", false);
  }
  cerrar() {
    $("#modal").empty();
  }
  siguiente() {
    if ($("#plantilla_nombre").val() === "") {
      alert("Por favor, ingrese un nombre para la plantilla.");
      return;
    } else {
      if (this.currentStep < this.pageTargets.length - 1) {
        this.currentStep++;
        this.mostrarPaso();
      }
    }
  }
  siguientePaso3() {
    if (this.currentStep < this.pageTargets.length - 1) {
      this.currentStep++;
      this.mostrarPaso();
    }
    this.cargarMesasSeleccionadas();
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
  agregarDetalle(event) {
    console.log("entra en agregarDetalle");
    console.log("Índice actual:", this.index2);
    let mesaId = event.currentTarget.dataset.mesaId;

    console.log(mesaId);
    /*    let html = this.templateTarget.innerHTML;

    html = html.replaceAll("INDEX", this.index2);

    //console.log("HTML generado:", html);

    this.detallesTarget.insertAdjacentHTML("beforeend", html);
*/
    $.ajax({
      url: "detalle",
      type: "GET",
      success: function (html) {
        console.log($("#index").val());
        html = html.replaceAll("INDEX", $("#index").val());
        html = html.replaceAll("MESAID",mesaId)
        console.log(html)
        $("#template" + mesaId).append(html);
      },
      error: function () {
        alert("Error al cargar el formulario");
      },
    });
    var int = $("#index").val();
    int++;
    console.log(int);
    $("#index").val(int);
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
    let horarios = $('input[name="plantilla[mesa_ids][]"]')
      .map(function () {
        return $(this).val();
      })
      .get();

    console.log(horarios);
    ajaxTurbo("/plantillas/mesas_seleccionadas", { seleccionada: true });
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
