class AddRetryToGames < ActiveRecord::Migration
  def change
    add_column :games, :retry, :boolean
  end
end
