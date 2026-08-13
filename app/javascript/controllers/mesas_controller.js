import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["contenedor", "template"];

  agregar() {
    const contenido = this.templateTarget.innerHTML;
    const nuevoId = new Date().getTime();

    const html = contenido.replace(/NEW_RECORD/g, nuevoId);

    this.contenedorTarget.insertAdjacentHTML("beforeend", html);
  }

  eliminar(event) {
    const mesa = event.currentTarget.closest(".mesa-card");

    if (!mesa) return;

    const destroyField = mesa.querySelector(".destroy-field");

    if (destroyField) {
      destroyField.value = "1";
      mesa.style.display = "none";
    } else {
      mesa.remove();
    }
  }
}
