import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdownMenu", "dropdownArrow"]
  closeFunctionRef = this.closeOnOutsideClick.bind(this);

  connect() { }

  disconnect() {
    document.removeEventListener("click", this.closeFunctionRef);
  }

  toggle() {
    if (this.dropdownMenuTarget.classList.contains("hidden")) {
      this.show();
    } else {
      this.hide();
    }
  }

  show() {
    this.dropdownMenuTarget.classList.remove("hidden");
    this.dropdownArrowTarget.classList.add("rotate-180");
    document.addEventListener("click", this.closeFunctionRef);
  }

  hide() {
    this.dropdownMenuTarget.classList.add("hidden");
    this.dropdownArrowTarget.classList.remove("rotate-180");
    document.removeEventListener("click", this.closeFunctionRef);
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.hide();
    }
  }
}
