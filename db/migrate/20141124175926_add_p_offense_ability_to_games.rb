class AddPOffenseAbilityToGames < ActiveRecord::Migration
  def change
    add_column :games, :pOffenseAbility, :string
  end
end
