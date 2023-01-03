import ApplicationController from './application_controller'

// 
// This is the Stimulus controller for the Example Reflex.
//
// It corresponds to the server-side Reflex class located at /app/reflexes/example.rb
//
// Learn more at: https://docs.stimulusreflex.com/rtfm/reflexes
//

export default class extends ApplicationController {
  connect () {
    //
    // StimulusReflex overrides the Stimulus `connect` method. Make sure to call
    // `super.connect()` so that any code in your superclass `connect` is run.
    //
    super.connect()
  }

  // With StimulusReflex active in your project, it will continuously scan your DOM for
  // `data-reflex` attributes on your elements, even if they are dynamically created.
  //
  //   <a href="#" data-reflex="click->Example#dance">Dance!</a>
  //
  // We call this a "declared" Reflex, because it doesn't require any JS to run.
  //
  // When your user clicks this link, a Reflex is launched and it calls the `dance` method
  // on your Example Reflex class. You don't have to do anything else!
  //
  // This Stimulus controller doesn't even need to exist for StimulusReflex to work its magic.
  // https://docs.stimulusreflex.com/rtfm/reflexes#declaring-a-reflex-in-html-with-data-attributes
  //
  // However...
  //
  // If we do create an `example` Stimulus controller that extends `ApplicationController`,
  // we can unlock several additional capabilities, including creating Reflexes with code.
  //
  //   <a href="#" data-controller="example" data-action="example#dance">Dance!</a>
  //
  // StimulusReflex gives our controller a new method, `stimulate`:
  //
  // dance() {
  //   this.stimulate('Example#dance')
  // }
  //
  // The `stimulate` method is very flexible, and it gives you the opportunity to pass
  // parameter options that will be passed to the `dance` method on the server.
  // https://docs.stimulusreflex.com/rtfm/reflexes#calling-a-reflex-in-a-stimulus-controller
  //
  // Reflex lifecycle methods
  //
  // For every method defined in your Reflex class, a matching set of optional
  // lifecycle callback methods become available in this javascript controller.
  // https://docs.stimulusreflex.com/rtfm/lifecycle#client-side-reflex-callbacks
  //
  //   <a href="#" data-reflex="click->Example#dance" data-controller="example">Dance!</a>
  //
  // StimulusReflex will check for the presence of several methods:
  //
  //   afterReflex(element, reflex, noop, id) {
  //     // fires after every Example Reflex action
  //   }
  //
  //   afterDance(element, reflex, noop, id) {
  //     // fires after Example Reflexes calling the dance action
  //   }
  //
  // Arguments:
  //
  //   element - the element that triggered the reflex
  //             may be different than the Stimulus controller's this.element
  //
  //   reflex - the name of the reflex e.g. "Example#dance"
  //
  //   error/noop - the error message (for reflexError), otherwise null
  //
  //   id - a UUID4 or developer-provided unique identifier for each Reflex
  //
  // Access to the client-side Reflex objects created by this controller
  //
  // Every Reflex you create is represented by an object in the global Reflexes collection.
  // You can access the Example Reflexes created by this controller via the `reflexes` proxy.
  //
  //   this.reflexes.last
  //   this.reflexes.all
  //   this.reflexes.all[id]
  //   this.reflexes.error
  //
  // The proxy allows you to access the most recent Reflex, an array of all Reflexes, a specific
  // Reflex specified by its `id` and an array of all Reflexes in a given lifecycle stage.
  //
  // If you explore the Reflex object, you'll see all relevant details,
  // including the `data` that is being delivered to the server.
  //
  // Pretty cool, right?
  //
}
