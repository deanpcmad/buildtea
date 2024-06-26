class ReposController < ApplicationController

  before_action :set_repo, only: [:show, :builds, :gitea, :buildkite]

  def index
    @title = "All Repos"
    @repos = Repo.all
  end

  def new
    @title = "New Repo"
    @repo = Repo.new

    @gitea_repos = []
    page = 0

    repos = Buildtea::GITEA_CLIENT.user_repos.list limit: 50

    if repos.total > 0

      loop do
        page += 1
        repos = Buildtea::GITEA_CLIENT.user_repos.list limit: 50, page: page

        if repos.total == 0
          break
        else
          @gitea_repos.push *repos.data.map {|r| {id: r.id, full_name: r.full_name, owner: r.owner.login, name: r.name, desc: r.description, url: r.ssh_url}}
        end
      end

    end

    @gitea_repos.flatten!

    @gitea_repos.sort_by! { |r| r[:owner] }

    @gitea_repos = @gitea_repos.map{|repo| [
      repo[:full_name],
      repo[:id],
      data: {owner: repo[:owner], name: repo[:name], desc: repo[:desc], url: repo[:url]}
    ]}

    clusters = Buildkite::Cluster.list

    @buildkite_clusters = clusters.data.map{|cluster| [
      cluster.name,
      cluster.id
    ]}

    pipelines = Buildkite::Pipeline.list

    @buildkite_pipelines = pipelines.data.map{|pipeline| [
      pipeline.name,
      pipeline.slug,
      data: {id: pipeline.id}
    ]}
  end

  def show
    @title = "Repo #{@repo.name}"
  end

  def builds
    @title = "Builds for #{@repo.name}"
    @builds = @repo.builds.order(created_at: :desc)
  end

  def gitea
    begin
      @repo.create_webhook
      redirect_to @repo, notice: "Gitea Webhook Created"
    rescue
      redirect_to @repo, alert: "Error creating Gitea Webhook. Make sure your Access Token has permissions to create webhooks"
    end
  end

  def buildkite
    begin
      @repo.create_pipeline
      redirect_to @repo, notice: "Buildkite Pipeline Created"
    rescue
      redirect_to @repo, alert: "Error creating Buildkite Pipeline. Make sure your Access Token has permissions to create pipelines"
    end
  end

  def create
    @repo = Repo.new(safe_params)
    if @repo.save
      redirect_to @repo, notice: "Created '#{@repo.name}' Repo"
    else
      render :new, status: :see_other
    end
  end

  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy
    redirect_to repos_path, notice: "Repo deleted", status: :see_other
  end

  private

  def safe_params
    params.require(:repo).permit(:gitea_id, :name, :repo_owner, :repo_name, :repo_url, :description, :buildkite_slug, :buildkite_cluster, :buildkite_id)
  end

  def set_repo
    @repo = Repo.find(params[:id])
  end

end
