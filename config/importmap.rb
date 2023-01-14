# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/config", under: "config"
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.0.4/app/assets/javascripts/actioncable.esm.js"
pin "cable_ready", to: "https://ga.jspm.io/npm:cable_ready@5.0.0-pre8/javascript/index.js"
pin "stimulus_reflex", to: "https://ga.jspm.io/npm:stimulus_reflex@3.5.0-pre8/javascript/stimulus_reflex.js"
pin "morphdom", to: "https://ga.jspm.io/npm:morphdom@2.6.1/dist/morphdom.js"
pin "fireworks-js", to: "https://ga.jspm.io/npm:fireworks-js@2.10.0/dist/index.es.js"
pin "mrujs", to: "https://ga.jspm.io/npm:mrujs@0.10.1/dist/index.module.js"
pin "mrujs/plugins", to: "https://ga.jspm.io/npm:mrujs@0.10.1/plugins/dist/plugins.module.js"
pin "stimulus", to: "https://ga.jspm.io/npm:stimulus@3.2.1/dist/stimulus.js"
