import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "clearLink", "container" ]

  connect() {
    if (this.activeFilters.length > 0) {
      this.clearLinkTarget.classList.remove("hidden");
    }
  }

  show(event) {
    event.preventDefault();
    this.containerTarget.classList.remove("hidden");
  }

  update() {
    let params = [...this.categoryContainers].map((categoryContainer) => {
      let activeFilters = categoryContainer.querySelectorAll('input[type=checkbox]:checked');

      return [...activeFilters].map((activeFilter) => `${categoryContainer.id}[]=${activeFilter.value}`);
    }).flat().join('&');

    if (params) {
      Turbolinks.visit(`/?${params}`);
    } else {
      Turbolinks.visit("/");
    }
  }

  get categoryContainers() {
    return this.data.element.querySelectorAll('.category');
  }

  get activeFilters() {
    return this.data.element.querySelectorAll('input[type=checkbox]:checked');
  }
}

