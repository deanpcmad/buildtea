class Build < ApplicationRecord

  belongs_to :repo

  before_create {
    self.status = "New"
  }

  def create_status
    return if status == "new"

    if status == "passed"
      st = "success"
    elsif status == "failed"
      st = "failure"
    elsif status == "scheduled"
      st = "pending"
    elsif status == "running"
      st = "pending"
    elsif status == "canceled"
      st = "warning"
    end

    return unless st

    Buildtea::GITEA_CLIENT.commit_statuses.create(
      owner: repo.repo_owner,
      repo: repo.repo_name,
      sha: commit,
      state: st,
      target_url: bk_url,
      description: "Build ##{number}"
    )
  end

  def bk_url
    "https://buildkite.com/#{ENV["BUILDKITE_SLUG"]}/#{repo.buildkite_slug}/builds/#{number}"
  end

  def buildkite_build
    repo.account.buildkite_client.builds.get(org: repo.account.buildkite_slug, pipeline: repo.buildkite_slug, number: number)
  end

  def badge
    case status
    when "passed"
      "bg-green"
    when "failed"
      "bg-red"
    when "running"
      "bg-yellow"
    when "scheduled"
      "bg-azure"
    else
      "bg-secondary"
    end
  end

  def create_buildkite_build
    return if number.present?

    build = Buildtea::BUILDKITE_CLIENT.builds.create(
      org: ENV["BUILDKITE_SLUG"],
      pipeline: repo.buildkite_slug,
      commit: commit,
      branch: branch,
      message: message,
      author: {name: author_name, email: author_email}
    )

    update(buildkite_id: build.id, number: build.number, status: build.state)
  end

end
