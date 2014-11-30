class AddFirstToGames < ActiveRecord::Migration
  def change
    add_column :games, :npc_first, :boolean
    add_column :games, :p_first, :boolean
  end
end
