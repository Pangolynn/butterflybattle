class AddPDefenseAbilityToGames < ActiveRecord::Migration
  def change
    add_column :games, :pDefenseAbility, :string
  end
end
