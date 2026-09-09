import { Controller } from "@hotwired/stimulus"
import $ from "jquery";
// Connects to data-controller="relacion"
export default class extends Controller {
  connect() {
    console.log("relacion_controller.js conectado");
    document.addEventListener("click", function (event) {
      const boton = event.target.closest(".btn-tabla-editar");
      console.log("boton", boton);
      if (boton) {
        event.stopPropagation();
      }
    });
  }
}
