class AddBleedToGames < ActiveRecord::Migration
  def change
    add_column :games, :bleed, :boolean
  end
end
