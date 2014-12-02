class AddScoreToGames < ActiveRecord::Migration
  def change
    add_column :games, :p_score, :integer
  end
end
