import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  cargar() {
    this.buttonTarget.disabled = true;

    this.buttonTarget.innerHTML = `
      <span class="spinner-border spinner-border-sm me-2"
            role="status"></span>
      Guardando...
    `;
  }

  terminar() {
    this.buttonTarget.disabled = false;

    this.buttonTarget.innerHTML = "Guardar";
  }
}