class AddCondToGames < ActiveRecord::Migration
  def change
    add_column :games, :p_lose_turn, :boolean
    add_column :games, :npc_lose_turn, :boolean
    add_column :games, :p_confused, :boolean
    add_column :games, :npc_confused, :boolean
    add_column :games, :p_forget, :boolean
    add_column :games, :npc_forget, :boolean
  end
end
