class AddBuildkiteClusterToRepos < ActiveRecord::Migration[7.1]
  def change
    add_column :repos, :buildkite_cluster, :string
  end
end
