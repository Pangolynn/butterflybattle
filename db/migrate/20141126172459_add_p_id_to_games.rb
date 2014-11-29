class AddPIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :p_id, :string
  end
end
