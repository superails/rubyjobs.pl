import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  close() {
    console.log("OK");
    this.containerTarget.remove();
  }
}

