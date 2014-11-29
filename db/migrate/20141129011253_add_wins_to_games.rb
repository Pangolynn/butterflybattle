class AddWinsToGames < ActiveRecord::Migration
  def change
    add_column :games, :p_win, :boolean
    add_column :games, :npc_win, :boolean
    add_column :games, :p_loss_counter, :integer
  end
end
