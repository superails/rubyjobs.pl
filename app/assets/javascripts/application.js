// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require trix
//= require_tree .

  document.addEventListener("turbolinks:load", function() {
    var closeFlashMessageButton = document.getElementById("close-flash-message");

    if (closeFlashMessageButton) {
      closeFlashMessageButton.onclick = function() {
        var flashMessageBox = document.getElementById("flash-message");
        flashMessageBox.remove();
      }
    }

    var menuButton = document.getElementById("open-top-nav");

    if (menuButton) {
      menuButton.onclick = function() {
        var menuContent = document.getElementById("top-nav");
        if (menuContent.classList.contains('hidden')) {
          menuContent.classList.add('md:hidden');
          menuContent.classList.remove('hidden');
        } else {
          menuContent.classList.add('hidden');
        }
      }
    }
  });

  document.addEventListener("turbolinks:load", function() {
    document.querySelector('#filters').onclick = function(event) {
      if (event.target.value) {
        categoryContainers = document.querySelectorAll('.category');

        params = [...categoryContainers]
          .map(function(categoryContainer) {
            categoryFacets = [...categoryContainer.querySelectorAll('input[type=checkbox]:checked')].map(checkbox => checkbox.value)
            return [categoryContainer.id, categoryFacets]})
          .filter(facetTuple => facetTuple[1].length > 0 )
          .map(facetTuple => facetTuple[1].map(facet => facetTuple[0] + "[]=" + facet))
          .flat().join('&');

        if (params) {
          Turbolinks.visit("/?" + params);
        } else {
          Turbolinks.visit("/");
        }

      }
    }

  });
