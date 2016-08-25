class CreateIntegrations < ActiveRecord::Migration[5.0]
  def change
    create_table :integrations do |t|
      t.string :access_token
      t.string :user_id
      t.string :team_id
      t.string :team_name
      t.string :channel
      t.string :channel_id
      t.string :url
      t.string :cofiguration_url

      t.timestamps
    end
  end
end
