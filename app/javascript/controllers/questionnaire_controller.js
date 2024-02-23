import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questionnaire"
export default class extends Controller {
  static targets = ["question", "submit", "next", "back", "source", "preview"]

  initialize() {
    this.showCurrentQuestion(0);
  }

  next() {
    if (!this.validateResponse()) {
      alert("Пожалуйста, дайте ответ на текущий вопрос.");
      return;
    }
    const currentIndex = this.currentQuestionIndex();
    if (currentIndex < this.questionTargets.length - 1) {
      this.showCurrentQuestion(currentIndex + 1);
    }
    this.updateButtonVisibility();
  }


  previous() {
    const currentIndex = this.currentQuestionIndex();
    if (currentIndex > 0) {
      this.showCurrentQuestion(currentIndex - 1);
    }
    this.updateButtonVisibility();
  }

  updateButtonVisibility() {
    const currentIndex = this.currentQuestionIndex();
    this.backTarget.classList.toggle("d-none", currentIndex === 0);
    this.nextTarget.classList.toggle("d-none", currentIndex === this.questionTargets.length - 1);
    this.submitTarget.classList.toggle("d-none", currentIndex !== this.questionTargets.length - 1);
  }

  validateResponse() {
    const currentIndex = this.currentQuestionIndex();
    const currentQuestion = this.questionTargets[currentIndex];
    const inputType = currentQuestion.querySelector("input, select, textarea").getAttribute("type");
    if (inputType === "file") {
      return currentQuestion.querySelector("input").files.length > 0;
    } else {
      return currentQuestion.querySelector("input, select, textarea").value.trim() !== "";
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

  submit(event) {
    const isValid = this.element.checkValidity();
    if (!isValid) {
      event.preventDefault();
      this.element.reportValidity();
      const firstInvalidInput = this.element.querySelector(":invalid");
      const questionIndex = this.findQuestionIndex(firstInvalidInput);
      this.showCurrentQuestion(questionIndex);
      alert("Пожалуйста, дайте ответ на все вопросы.");
    }
  }

  findQuestionIndex(input) {
    let parentQuestion = input.closest("[data-questionnaire-target='question']");
    return this.questionTargets.indexOf(parentQuestion);
  }
}
