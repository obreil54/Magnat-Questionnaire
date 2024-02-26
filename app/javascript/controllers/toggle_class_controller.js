import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-class"
export default class extends Controller {
  static targets = ["toggleable", "status"]

  connect() {
    console.log("Connected to toggle-class controller")
  }

  toggleClass() {
    const isStatusChecked = this.statusTarget.checked
    this.toggleableTargets.forEach((element) => {
      element.classList.toggle("d-none", !isStatusChecked)
    });
  }
}
