class AddConditionToGames < ActiveRecord::Migration
  def change
    add_column :games, :npc_renew, :boolean
    add_column :games, :p_renew, :boolean
    add_column :games, :npc_bleed, :boolean
    add_column :games, :p_bleed, :boolean
  end
end
