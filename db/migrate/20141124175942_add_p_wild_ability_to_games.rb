class AddPWildAbilityToGames < ActiveRecord::Migration
  def change
    add_column :games, :pWildAbility, :string
  end
end
