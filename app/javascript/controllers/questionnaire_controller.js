import { Controller } from "@hotwired/stimulus"

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

  async show(event) {
    const index = this.sourceTargets.indexOf(event.target);
    const previewTarget = this.previewTargets[index];
    const file = event.target.files[0];
    const currentIndex = this.currentQuestionIndex();
    const currentQuestion = this.questionTargets[currentIndex];

    if (file && file.type.match('image')) {
      try {
        const resizedFile = await this.resizeImage(file);
        const reader = new FileReader();
        reader.onload = function(e) {
          previewTarget.innerHTML = `<img src="${e.target.result}">`
        };
        reader.readAsDataURL(resizedFile);
        this.lastSelectedImages[currentQuestion.dataset.itemQuestionId] = resizedFile;
        this.hasUnsavedChanges = true;
      } catch (error) {
        console.error("Error resizing image:", error);
      }
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
    const currentQuestion = this.questionTargets[currentIndex];
    const input = currentQuestion.querySelector("input, select, textarea");
    const name = input.name;
    const value = input.value;

    let payload = {
      question_id: currentQuestion.dataset.itemQuestionId,
      hardware_id: currentQuestion.dataset.itemHardwareId,
      questionnaire_id: currentQuestion.dataset.itemQuestionnaireId,
      answer: value,
    };

    if (isFinal) {
      payload.is_final = true;
    }

    if (input.type === "file") {
      let file = input.files[0];
      if (file) {
        try {
          file = await this.resizeImage(file);
          const fileBlob = new Blob([file], { type: file.type });
          payload.answer = fileBlob;
        } catch (error) {
          console.error("Error resizing image:", error);
        }
      } else if (this.lastSelectedImages[currentQuestion.dataset.itemQuestionId]) {
        payload.answer = this.lastSelectedImages[currentQuestion.dataset.itemQuestionId];
        this.lastSelectedImages[currentQuestion.dataset.itemQuestionId] = null;
      } else if (currentQuestion.dataset.existingImage) {
        payload.keep_existing_image = true;
      }
    }

    const formData = new FormData();
    Object.keys(payload).forEach(key => formData.append(key, payload[key]));

    try {
      const response = await fetch(this.responseDetailsPathValue, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
        },
        body: formData,
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

  resizeImage(file, maxWidth = 1024, maxHeight = 1024, quality = 0.7) {
    return new Promise((resolve, reject) => {
      const img = document.createElement("img");
      const reader = new FileReader();

      reader.onload = function(e) {
        img.src = e.target.result;

        img.onload = function() {
          let width = img.width;
          let height = img.height;

          if (width > height) {
            if (width > maxWidth) {
              height *= maxWidth / width;
              width = maxWidth;
            }
          } else {
            if (height > maxHeight) {
              width *= maxHeight / height;
              height = maxHeight;
            }
          }

          const canvas = document.createElement("canvas");
          canvas.width = width;
          canvas.height = height;
          const ctx = canvas.getContext("2d");
          ctx.drawImage(img, 0, 0, width, height);

          canvas.toBlob((blob) => {
            resolve(new File([blob], file.name, { type: file.type, lastModified: Date.now() }));
          }, file.type, quality);
        };

        img.onerror = function(err) {
          reject(err);
        };
      };

      reader.onerror = function(err) {
        reject(err);
      };

      reader.readAsDataURL(file);
    });
  }
}
