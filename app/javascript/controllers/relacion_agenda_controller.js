import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
// Connects to data-controller="relacion-agenda"
export default class extends Controller {
  static targets = [
    "relacion",
    "mesa",
    "titulo",
    "calendario",
    "seleccionados",
    "dia",
  ];
  connect() {
    console.log("se conecto a relacion-agenda");
    this.fechaActual = new Date();
    this.mes = this.fechaActual.getMonth();
    this.anio = this.fechaActual.getFullYear();

    this.diasDisponibles = [];
    this.fechasSeleccionadas = new Set();
    this.dibujarCalendario();
    //iniciarSemana();
    $("#medico_id").prop("disabled", true);
    $("#medico_id").val(0).trigger("change");
    $("#plantilla_id").val(null).trigger("change");
    $("#plantilla_id").on("change", function () {
      $("#medico_id").prop("disabled", false);
      console.log("plantilla_id: " + $(this).val());
      ajaxTurbo("setMesas", {
        plantilla_id: $(this).val(),
      });
    });
  }
  async cargarDias() {
    console.log("cargando dias");
    //console.log(this.mesaTarget.value);
    //const relacionId = this.relacionTarget.value;
    const mesaId = this.mesaTarget.value;

    this.diasDisponibles = [];
    this.fechasSeleccionadas.clear();

    this.actualizarSeleccionados();
    console.log("mesaId: " + mesaId);
    if (mesaId == null) {
      console.log("dibujando calendario");
      this.dibujarCalendario();
      return;
    }
    var plantillaId = $("#plantilla_id").val();
    console.log("plantillaId: " + plantillaId);
    $.ajax({
      url: "dias_disponibles",
      type: "GET",
      dataType: "json",
      data: {
        plantilla_id: plantillaId,
        mesa_id: mesaId,
      },
      success: (response) => {
        this.diasDisponibles = response;
        console.log("Días disponibles:", this.diasDisponibles);
        this.dibujarCalendario();
      },
      error: (xhr, status, error) => {
        console.error("Error consultando los días disponibles:", error);
      },
    });
  }
  seleccionarTodos() {
    console.log("seleccionando todos los días disponibles");
    this.diaTargets.forEach((element) => {
      // Si el día está disponible
      if (!element.disabled) {
        const fecha = element.dataset.fecha;

        if (fecha) {
          this.fechasSeleccionadas.add(fecha);
        }
      }
    });

    this.dibujarCalendario();
    this.actualizarSeleccionados();
  }

  limpiarSeleccion() {
    this.fechasSeleccionadas.clear();

    this.dibujarCalendario();
    this.actualizarSeleccionados();
  }

  seleccionarFecha(fecha) {
    if (this.fechasSeleccionadas.has(fecha)) {
      this.fechasSeleccionadas.delete(fecha);
    } else {
      this.fechasSeleccionadas.add(fecha);
    }

    this.dibujarCalendario();
    this.actualizarSeleccionados();
  }

  actualizarSeleccionados() {
    this.seleccionadosTarget.innerHTML = "";

    Array.from(this.fechasSeleccionadas)
      .sort()
      .forEach((fecha) => {
        const input = document.createElement("input");

        input.type = "hidden";
        input.name = "asignaciones[fechas][]";
        input.value = fecha;

        this.seleccionadosTarget.appendChild(input);
      });
  }

  anterior() {
    this.mes--;

    if (this.mes < 0) {
      this.mes = 11;
      this.anio--;
    }

    this.dibujarCalendario();
  }

  siguiente() {
    this.mes++;

    if (this.mes > 11) {
      this.mes = 0;
      this.anio++;
    }

    this.dibujarCalendario();
  }

  hoy() {
    this.fechaActual = new Date();
    this.mes = this.fechaActual.getMonth();
    this.anio = this.fechaActual.getFullYear();

    this.dibujarCalendario();
  }

  formatoFecha(fecha) {
    const anio = fecha.getFullYear();
    const mes = String(fecha.getMonth() + 1).padStart(2, "0");
    const dia = String(fecha.getDate()).padStart(2, "0");

    return `${anio}-${mes}-${dia}`;
  }
  dibujarCalendario() {
    const fechaPrimera = new Date(this.anio, this.mes, 1);

    // Convertir domingo (0) a posición 6
    const desplazamiento = (fechaPrimera.getDay() + 6) % 7;

    // Total de celdas necesarias para cubrir el mes
    const totalDias = new Date(this.anio, this.mes + 1, 0).getDate();

    const totalCeldas = Math.ceil((desplazamiento + totalDias) / 7) * 7;

    this.tituloTarget.textContent = fechaPrimera.toLocaleDateString("es-MX", {
      month: "long",
      year: "numeric",
    });

    this.calendarioTarget.innerHTML = "";

    for (let i = 0; i < totalCeldas; i++) {
      const numeroDia = i - desplazamiento + 1;

      const fecha = new Date(this.anio, this.mes, numeroDia);

      const esMesActual = fecha.getMonth() === this.mes;

      const diaSemana = [
        "domingo",
        "lunes",
        "martes",
        "miercoles",
        "jueves",
        "viernes",
        "sabado",
      ][fecha.getDay()];

      const fechaISO = this.formatoFecha(fecha);

      const disponible =
        esMesActual && this.diasDisponibles.includes(diaSemana);

      const seleccionado = this.fechasSeleccionadas.has(fechaISO);

      const celda = document.createElement("button");

      celda.type = "button";
      celda.className = "calendario-celda";

      celda.classList.toggle("fuera-mes", !esMesActual);

      celda.classList.toggle("dia-disponible", disponible);

      celda.classList.toggle("dia-bloqueado", esMesActual && !disponible);

      celda.classList.toggle("dia-seleccionado", seleccionado);
      celda.dataset.relacionAgendaTarget = "dia";
      celda.dataset.fecha = fechaISO;

      celda.disabled = !disponible;

      celda.innerHTML = `
        <span class="numero-dia">
          ${fecha.getDate()}
        </span>

        ${
          disponible
            ? `<span class="estado-dia">
                 ${seleccionado ? "Seleccionado" : "Disponible"}
               </span>`
            : esMesActual
              ? `<span class="estado-dia">No disponible</span>`
              : ""
        }
      `;

      if (disponible) {
        celda.addEventListener("click", () => {
          this.seleccionarFecha(fechaISO);
        });
      }

      this.calendarioTarget.appendChild(celda);
    }
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
  const proximoViernes = new Date(proximoLunes);
  proximoViernes.setDate(proximoLunes.getDate() + 4);
  console.log(proximoLunes.toISOString().split("T")[0]);
  console.log(proximoViernes.toISOString().split("T")[0]);
  $("#agenda_fecha_inicio").val(proximoLunes.toISOString().split("T")[0]);
  $("#agenda_fecha_fin").val(proximoViernes.toISOString().split("T")[0]);
}