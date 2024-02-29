import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questionnaire"
export default class extends Controller {
  static targets = ["question", "submit", "next", "back", "source", "preview"]
  static values = { responseDetailsPath: String }

  initialize() {
    this.showCurrentQuestion(0);
  }

  next() {
    if (!this.validateResponse()) {
      alert("Пожалуйста, дайте ответ на текущий вопрос.");
      return;
    }
    const currentIndex = this.currentQuestionIndex();
    this.sendResponse().then(response => {
      if (response.ok) {
        if (currentIndex < this.questionTargets.length - 1) {
          this.showCurrentQuestion(currentIndex + 1);
        }
        this.updateButtonVisibility();
      } else {
        alert("Произошла ошибка. Пожалуйста, попробуйте еще раз.");
      }
    });
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
    event.preventDefault();
    if (!this.validateResponse) {
      alert("Пожалуйста, дайте ответ на текущий вопрос.");
      return;
    }
    const isFinal = true;
    this.sendResponse(isFinal).then(() => {
      window.location.href = "/profile";
    }).catch(() => {
      alert("Произошла ошибка. Пожалуйста, попробуйте еще раз.");
    });
  }

  sendResponse(isFinal = false) {
    const currentIndex = this.currentQuestionIndex();
    const formData = new FormData(this.element);
    const currentQuestion = this.questionTargets[currentIndex];
    const input = currentQuestion.querySelector("input, select, textarea");

    formData.append("answer", input.value);
    formData.append("question_id", currentQuestion.dataset.itemQuestionId);
    formData.append("hardware_id", currentQuestion.dataset.itemHardwareId);
    formData.append("questionnaire_id", currentQuestion.dataset.itemQuestionnaireId);
    if (isFinal) {
      formData.append("is_final", true);
    }

    return fetch(this.responseDetailsPathValue, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
      },
      body: formData
    });
  }

  findQuestionIndex(input) {
    let parentQuestion = input.closest("[data-questionnaire-target='question']");
    return this.questionTargets.indexOf(parentQuestion);
  }
}
