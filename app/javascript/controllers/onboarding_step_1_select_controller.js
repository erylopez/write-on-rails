import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="onboarding-step-1-select"
export default class extends Controller {
  static targets = ["nextButton"]

  update() {
    this.nextButtonTarget.classList.remove("hidden")
  }
}
