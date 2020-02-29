import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "filtersContainer", "mainContainer", "showJobOffers" ]

  connect() {
    if (getCookie("filters") != "on") {
      this.hide();
    } else {
      this.show();
    }
  }
  
  show(event) {
    this.filtersContainerTarget.classList.remove("hidden");
    this.showJobOffersTarget.classList.remove("hidden");
    this.mainContainerTarget.classList.add("hidden");
    document.cookie = "filters=on";

    if(event) { event.preventDefault() }
  }

  hide() {
    this.filtersContainerTarget.classList.add("hidden");
    this.showJobOffersTarget.classList.add("hidden");
    this.mainContainerTarget.classList.remove("hidden");
    document.cookie = "filters=";
  }
}


