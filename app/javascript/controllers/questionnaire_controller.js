import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="questionnaire"
export default class extends Controller {
  static targets = ["question", "submit", "next", "back", "source", "preview", "error", "loading"]
  static values = { responseDetailsPath: String }

  initialize() {
    console.log("Questionnaire controller initialized test for 24/06/2024")
    this.showCurrentQuestion(0);
    this.lastSelectedImages = {};
    this.hasUnsavedChanges = false;
    this.initInputListeners();
  }

  initInputListeners() {
    this.questionTargets.forEach((question) => {
      const inputs = question.querySelectorAll("input, select, textarea");
      inputs.forEach((input) => {
        input.addEventListener("change", () => {
          this.hasUnsavedChanges = true;
        });
      });
    });
  }

  displayLoadingAnimation(show) {
    if (show) {
      this.loadingTarget.classList.remove("d-none");
    } else {
      this.loadingTarget.classList.add("d-none");
    }
  }

  async next() {
    if (!this.validateResponse()) {
        return;
    }
    if (this.hasUnsavedChanges) {
        this.displayLoadingAnimation(true);
        try {
            await this.sendResponse();
        } catch (error) {
            this.displayLoadingAnimation(false);
            return;
        }
    }
    const currentIndex = this.currentQuestionIndex();
    if (currentIndex < this.questionTargets.length - 1) {
        this.showCurrentQuestion(currentIndex + 1);
    }
    this.updateButtonVisibility();
  }

  async previous() {
    const currentIndex = this.currentQuestionIndex();

    if (!this.validateResponse()) {
        if (currentIndex > 0) {
            this.showCurrentQuestion(currentIndex - 1);
        }
        this.updateButtonVisibility();
        return;
    }
    if (this.hasUnsavedChanges) {
        this.displayLoadingAnimation(true);
        try {
            await this.sendResponse();
        } catch (error) {
            this.displayLoadingAnimation(false);
            return;
        }
    }
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
      const lastSelectedImage = this.lastSelectedImages[currentQuestion.dataset.itemQuestionId];
      isValid = fileSelected || existingImage || this.lastSelectedImages[currentQuestion.dataset.itemQuestionId];
    }

    const errorMessageDiv = this.errorTargets[currentIndex];
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
    });
    this.hasUnsavedChanges = false;
  }

  updateImagePreview(questionElement) {
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
    const currentIndex = this.currentQuestionIndex();
    const currentQuestion = this.questionTargets[currentIndex];

    if (file && file.type.match('image')) {
      const reader = new FileReader();
      reader.onload = function(e) {
        previewTarget.innerHTML = `<img src="${e.target.result}">`
      };
      reader.readAsDataURL(file);
      this.lastSelectedImages[currentQuestion.dataset.itemQuestionId] = file;
      this.hasUnsavedChanges = true;
    }
  }

  async submit(event) {
    event.preventDefault();
    if (!this.validateResponse()) {
        return;
    }
    this.displayLoadingAnimation(true);

    try {
        const isFinal = true;
        await this.sendResponse(isFinal);
        window.location.href = "/success";
    } catch (error) {
        this.displayLoadingAnimation(false);
    }
  }

  async sendResponse(isFinal = false) {
    const currentIndex = this.currentQuestionIndex();
    const formData = new FormData(this.element);
    const currentQuestion = this.questionTargets[currentIndex];
    const inputs = currentQuestion.querySelectorAll("input, select, textarea");

    inputs.forEach(input => {
        const name = input.name;
        const value = input.value;
        if (input.type === "file") {
            const file = input.files[0];
            if (file) {
                formData.append("answer", file);
            } else if (this.lastSelectedImages[currentQuestion.dataset.itemQuestionId]) {
                formData.append("answer", this.lastSelectedImages[currentQuestion.dataset.itemQuestionId]);
            } else if (currentQuestion.dataset.existingImage) {
                formData.append("keep_existing_image", true);
            }
        } else {
            formData.append("answer", value);
        }
    });

    formData.append("question_id", currentQuestion.dataset.itemQuestionId);
    formData.append("hardware_id", currentQuestion.dataset.itemHardwareId);
    formData.append("questionnaire_id", currentQuestion.dataset.itemQuestionnaireId);
    if (isFinal) {
        formData.append("is_final", true);
    }

    try {
        const response = await fetch(this.responseDetailsPathValue, {
            method: 'POST',
            headers: {
                'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
            },
            body: formData
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || `HTTP Status ${response.status}`);
        }

        this.hasUnsavedChanges = false;
        return response;

    } catch (error) {
        console.error("Error sending response:", error);
        this.displayErrorMessage(currentQuestion, error.message);
        throw error;
    } finally {
        this.displayLoadingAnimation(false);
    }
  }

  displayErrorMessage(questionElement, message) {
    const errorMessageDiv = questionElement.querySelector("[data-questionnaire-target='error']");
    if (errorMessageDiv) {
      errorMessageDiv.style.display = "block";
      errorMessageDiv.textContent = message;
    }
  }

  findQuestionIndex(input) {
    let parentQuestion = input.closest("[data-questionnaire-target='question']");
    return this.questionTargets.indexOf(parentQuestion);
  }
}
