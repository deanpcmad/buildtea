class CreateRepos < ActiveRecord::Migration[7.0]
  def change
    create_table :repos do |t|
      t.string :name
      t.string :repo_owner
      t.string :repo_name
      t.string :repo_url
      t.string :description
      t.integer :gitea_id
      t.integer :gitea_hook_id
      t.string :buildkite_id
      t.string :buildkite_slug
      t.string :webhook_token

      t.timestamps
    end
  end
end
