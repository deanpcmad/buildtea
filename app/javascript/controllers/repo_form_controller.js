import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="repo-form"
export default class extends Controller {

  handleGiteaChange() {
    var field = document.getElementById("repo_gitea_id");

    if (field.value === "") {
      document.getElementById("repo_name").value = "";
      document.getElementById("repo_repo_owner").value = "";
      document.getElementById("repo_repo_name").value = "";
      document.getElementById("repo_repo_url").value = "";
      document.getElementById("repo_description").value = "";
    } else {
      var selected = field.selectedOptions[0]

      document.getElementById("repo_name").value = selected.getAttribute("data-name");
      document.getElementById("repo_repo_owner").value = selected.getAttribute("data-owner");
      document.getElementById("repo_repo_name").value = selected.getAttribute("data-name");
      document.getElementById("repo_repo_url").value = selected.getAttribute("data-url");
      document.getElementById("repo_description").value = selected.getAttribute("data-desc");
    }
  }

  handleBuildkiteChange() {
    var field = document.getElementById("repo_buildkite_slug");

    if (field.value === "") {
      document.getElementById("repo_buildkite_id").value = "";
    } else {
      var selected = field.selectedOptions[0]

      document.getElementById("repo_buildkite_id").value = selected.getAttribute("data-id");
    }
  }

}
