import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "clearLink" ]

  connect() {
    if (this.activeFilters.length > 0) {
      this.clearLinkTarget.classList.remove("hidden");
    }
  }

  get activeFilters() {
    return this.data.element.querySelectorAll('input[type=checkbox]:checked');
  }
}

