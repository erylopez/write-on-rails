import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alertBox"];

  connect() {
    this.timeout = setTimeout(this.close.bind(this), 3000);
  }

  close() {
    this.alertBoxTarget.classList.add('transition-box');
    setTimeout(() => {
      this.alertBoxTarget.remove();
    }, 1000);
  }
}
