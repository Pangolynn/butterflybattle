class AddFileToGames < ActiveRecord::Migration
  def change
    add_column :games, :npc_file, :string
  end
end
