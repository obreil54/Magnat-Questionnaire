import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questionnaire"
export default class extends Controller {
  static targets = ["question", "submit"]

  initialize() {
    this.showCurrentQuestion(0);
  }

  next() {
    const currentIndex = this.currentQuestionIndex();
    if (currentIndex < this.questionTargets.length - 1) {
      this.showCurrentQuestion(currentIndex + 1);
    }
    if (this.currentQuestionIndex() === this.questionTargets.length - 1) {
      this.submitTarget.classList.remove("d-none");
    } else {
      this.submitTarget.classList.add("d-none");
    }
  }

  previous() {
    const currentIndex = this.currentQuestionIndex();
    if (currentIndex > 0) {
      this.showCurrentQuestion(currentIndex - 1);
    }
    if (this.currentQuestionIndex() === this.questionTargets.length - 1) {
      this.submitTarget.classList.remove("d-none");
    } else {
      this.submitTarget.classList.add("d-none");
    }
  }

  showCurrentQuestion(index) {
    this.questionTargets.forEach((element, i) => {
      element.classList.toggle("d-none", i !== index);
    })
  }

  currentQuestionIndex() {
    return this.questionTargets.findIndex((element) => !element.classList.contains("d-none"));
  }
}
