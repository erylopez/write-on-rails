import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="onboarding-step-1-select"
export default class extends Controller {
  static targets = ["nextButton"]

  update() {
    //disabled because we are runing low on time in the hackaton 😅
    //this.nextButtonTarget.classList.remove("hidden")
  }
}
