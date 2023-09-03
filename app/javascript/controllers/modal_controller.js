import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modalbox", "backdrop"];

  connect() { }

  disconnect() {
    document.removeEventListener("click", this.closeFunctionRef);
  }

  open() {
    this.modalboxTarget.classList.remove("hidden");
    this.backdropTarget.classList.remove("hidden");
  }

  close() {
    this.modalboxTarget.classList.add("hidden");
    this.backdropTarget.classList.add("hidden");
  }
}
