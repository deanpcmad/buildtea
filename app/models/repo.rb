class Repo < ApplicationRecord

  has_secure_token :webhook_token

  has_many :builds, dependent: :destroy

  def full_name
    [repo_owner, repo_name].join("/")
  end

  def gitea_setup?
    gitea_hook_id.present?
  end

  def buildkite_setup?
    buildkite_id.present?
  end

  def bk_url
    "https://buildkite.com/#{ENV["BUILDKITE_SLUG"]}/#{buildkite_slug}"
  end

  def create_pipeline
    return if buildkite_id.present?

    pipeline = Buildtea::BUILDKITE_CLIENT.pipelines.create(
      org: ENV["BUILDKITE_SLUG"],
      name: name,
      repository: repo_url,
      description: description,
      configuration: "steps:\n  - label: \":pipeline:\"\n    command: \"buildkite-agent pipeline upload\""
    )

    update(buildkite_id: pipeline.id, buildkite_slug: pipeline.slug)
  end

  def create_webhook
    return if gitea_hook_id.present?

    url = [ENV["APP_HOST"], "_gitea", webhook_token].join("/")

    webhook = Buildtea::GITEA_CLIENT.repo_hooks.create(owner: repo_owner, repo: repo_name, url: url, type: "gitea", active: true)

    update(gitea_hook_id: webhook.id)
  end

end
