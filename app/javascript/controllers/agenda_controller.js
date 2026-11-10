import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

// Connects to data-controller="agenda"
export default class extends Controller {
  static targets = [
    "relacion",
    "mesa",
    "titulo",
    "calendario",
    "seleccionados",
    "dia",
    "mes",
    "fechaInicio",
    "fechaFin",
    "periodo",
    "dias",
  ];

  static values = {
    url: String,
  };

  connect() {
    this.actualizarRango();
    console.log("se conecto a agenda"); 
  }
  
 
   actualizarRango() {
    const valor = this.mesTarget.value

    if (!valor) return

    const [anio, mes] = valor.split("-").map(Number)

    // Primer día del mes
    const primerDia = `${valor}-01`

    // Último día del mes
    const ultimoDiaNumero = new Date(anio, mes, 0).getDate()

    const ultimoDia = `${valor}-${String(ultimoDiaNumero).padStart(2, "0")}`

    // Asignar fechas al formulario
    this.fechaInicioTarget.value = primerDia
    this.fechaFinTarget.value = ultimoDia

    // Mostrar fechas en formato DD/MM/YYYY
    const formatoFecha = (fecha) => {
      const [anio, mes, dia] = fecha.split("-")
      return `${dia}/${mes}/${anio}`
    }

    this.periodoTarget.textContent =
      `${formatoFecha(primerDia)} — ${formatoFecha(ultimoDia)}`

    this.diasTarget.textContent = `${ultimoDiaNumero} días`
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
