# Pin npm packages by running ./bin/importmap

pin "application", to: "application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: false
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: false
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
pin "bootstrap", to: "bootstrap.min.js", preload: false
pin "@popperjs/core", to: "popper.js", preload: false
