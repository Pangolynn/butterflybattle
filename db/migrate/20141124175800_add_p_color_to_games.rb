class AddPColorToGames < ActiveRecord::Migration
  def change
    add_column :games, :pColor, :string
  end
end
