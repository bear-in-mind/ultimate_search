import StimulusReflex from "stimulus_reflex";
import { application } from "controllers/application";
import { cable } from "@hotwired/turbo-rails";

// Eager load all controllers defined in the import map under controllers/\*\*/\*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

// initialize StimulusReflex w/top-level await
const consumer = await cable.getConsumer();
StimulusReflex.initialize(application);
application.consumer = consumer;
