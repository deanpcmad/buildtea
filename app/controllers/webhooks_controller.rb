class WebhooksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def buildkite
    data = JSON.parse(request.body.read)

    event = data["event"]

    if event == "ping"
      head :ok
      return
    end

    build_id = data["build"]["id"]
    build_number = data["build"]["number"]
    build_status = data["build"]["state"]
    build_rebuilt = data["build"]["rebuilt_from"]
    repo_url = data["pipeline"]["repository"]

    repo = Repo.find_by repo_url: repo_url

    if repo
      build = repo.builds.find_or_create_by buildkite_id: build_id

      build.update(number: build_number, status: build_status)

      if build_rebuilt.present?
        old_build = repo.builds.find_by buildkite_id: build_rebuilt["id"]
        if old_build
          build.update(
            commit: old_build.commit,
            branch: old_build.branch,
            message: old_build.message,
            author_name: old_build.author_name,
            author_email: old_build.author_email
          )
        end
      end

      build.create_status

      head :ok
    else
      head 422
    end
  end

  def gitea
    data = JSON.parse(request.body.read)

    # If the ref is for a branch, then remove ref/heads
    if data["ref"].include?("refs/heads")
      branch = data["ref"].gsub("refs/heads/", "")
    else
      # or it could be a tag, which buildkite parses
      branch = data["ref"]
    end

    repo_id = data["repository"]["id"]
    commit = data["head_commit"]["id"]
    message = data["head_commit"]["message"].strip
    author_name = data["head_commit"]["author"]["name"]
    author_email = data["head_commit"]["author"]["email"]

    repo = Repo.find_by(webhook_token: params[:token])

    if repo.present?
      build = repo.builds.create commit: commit, branch: branch, message: message, author_name: author_name, author_email: author_email

      build.create_buildkite_build

      head :ok
    else
      head 422
    end
  end

end
