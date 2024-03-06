import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questionnaire"
export default class extends Controller {
  static targets = ["question", "submit", "next", "back", "source", "preview", "error"]
  static values = { responseDetailsPath: String }

  initialize() {
    this.showCurrentQuestion(0);
  }

  next() {
    if (!this.validateResponse()) {
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
    const input = currentQuestion.querySelector("input, select, textarea");
    const isRequired = input.required;
    const inputType = input.getAttribute("type");
    let isValid;

    if (inputType !== "file") {
      isValid = input.value.trim() !== "";
    } else {
      const fileSelected = input.files.length > 0;
      const existingImage = currentQuestion.dataset.existingImage && currentQuestion.dataset.existingImage.trim() !== "";
      isValid = fileSelected || existingImage;
    }

    const errorMessageDiv = this.errorTargets[currentIndex];
    console.log(isValid)
    console.log(isRequired)
    console.log(errorMessageDiv)
    if (!isValid && isRequired) {
      errorMessageDiv.style.display = "block";
      errorMessageDiv.textContent = "Пожалуйста, дайте ответ на текущий вопрос.";
      return false
    } else {
      errorMessageDiv.style.display = "none";
      return true
    }
  }

  showCurrentQuestion(index) {
    this.questionTargets.forEach((element, i) => {
      element.classList.toggle("d-none", i !== index);
      const errorMessageDiv = this.errorTargets[i];
      if (errorMessageDiv) {
        errorMessageDiv.style.display = "none";
      }
      if (i === index && element.dataset.existingImage) {
        this.updateImagePreview(element);
      }
    })
  }

  updateImagePreview(questionElement) {
    console.log("Updating question image preview.")
    const existingImageUrl = questionElement.dataset.existingImage;
    const previewTarget = questionElement.querySelector("[data-questionnaire-target='preview");
    if (existingImageUrl) {
      previewTarget.innerHTML = `<img src="${existingImageUrl}">`;
    } else {
      previewTarget.innerHTML = '';
    }
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
    if (!this.validateResponse()) {
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
    const inputType = input.getAttribute("type");

    formData.append("answer", input.value);
    formData.append("question_id", currentQuestion.dataset.itemQuestionId);
    formData.append("hardware_id", currentQuestion.dataset.itemHardwareId);
    formData.append("questionnaire_id", currentQuestion.dataset.itemQuestionnaireId);
    if (isFinal) {
      formData.append("is_final", true);
    }


    if (inputType === "file" && !input.files.length && currentQuestion.dataset.existingImage) {
      formData.append("keep_existing_image", "true");
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
