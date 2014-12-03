class AddSleepToGames < ActiveRecord::Migration
  def change
    add_column :games, :p_sleep, :boolean
    add_column :games, :npc_sleep, :boolean
  end
end
