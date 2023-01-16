import StimulusReflex from "stimulus_reflex";
import { application } from "controllers/application";
import { cable } from "@hotwired/turbo-rails";
import ApplicationController from "controllers/application_controller";

application.register("application", ApplicationController);
// initialize StimulusReflex w/top-level await
const consumer = await cable.getConsumer();
StimulusReflex.initialize(application);
application.consumer = consumer;
