class CreateBuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :builds do |t|
      t.references :repo, null: false, foreign_key: true
      t.string :buildkite_id
      t.string :number
      t.string :status
      t.string :commit
      t.string :branch
      t.text :message
      t.string :author_name
      t.string :author_email

      t.timestamps
    end
  end
end
