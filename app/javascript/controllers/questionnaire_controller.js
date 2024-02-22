import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questionnaire"
export default class extends Controller {
  static targets = ["question", "submit", "next", "back", "source", "preview"]

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
      this.nextTarget.classList.add("d-none");
    } else if (this.currentQuestionIndex() !== 0) {
      this.backTarget.classList.remove("d-none");
    } else {
      this.submitTarget.classList.add("d-none");
      this.nextTarget.classList.remove("d-none");
    }
  }

  previous() {
    const currentIndex = this.currentQuestionIndex();
    if (currentIndex > 0) {
      this.showCurrentQuestion(currentIndex - 1);
    }
    if (this.currentQuestionIndex() === this.questionTargets.length - 1) {
      this.submitTarget.classList.remove("d-none");
      this.nextTarget.classList.add("d-none");
    } else if (this.currentQuestionIndex() === 0) {
      this.backTarget.classList.add("d-none");
    } else {
      this.submitTarget.classList.add("d-none");
      this.nextTarget.classList.remove("d-none");
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

  show(event) {
    const index = this.sourceTargets.indexOf(event.target);
    const previewTarget = this.previewTargets[index];

    const file = event.target.files[0];
    if (file && file.type.match('image')) {
      const reader = new FileReader();
      reader.onload = function(e) {
        previewTarget.innerHTML = `<img src="${e.target.result}">`
      };
      reader.readAsDataURL(file);
    }
  }
}
