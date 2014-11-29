class AddVariablesToGames < ActiveRecord::Migration
  def change
    add_column :games, :p_max_health, :integer
    add_column :games, :p_cur_health, :integer
    add_column :games, :npc_max_health, :integer
    add_column :games, :npc_cur_health, :integer
    add_column :games, :p_max_speed, :integer
    add_column :games, :p_cur_speed, :integer
    add_column :games, :p_max_armor, :integer
    add_column :games, :p_cur_armor, :integer
    add_column :games, :p_max_attack, :integer
    add_column :games, :p_cur_attack, :integer
    add_column :games, :p_name, :string
    add_column :games, :p_stat_boost, :string
    add_column :games, :p_wild, :string
    add_column :games, :p_offense, :string
    add_column :games, :p_defense, :string
    add_column :games, :p_last_move, :string
    add_column :games, :npc_max_speed, :integer
    add_column :games, :npc_cur_speed, :integer
    add_column :games, :npc_max_armor, :integer
    add_column :games, :npc_cur_armor, :integer
    add_column :games, :npc_max_attack, :integer
    add_column :games, :npc_cur_attack, :integer
    add_column :games, :npc_name, :string
    add_column :games, :p_color, :string
    add_column :games, :npc_wild, :string
    add_column :games, :npc_offense, :string
    add_column :games, :npc_defense, :string
    add_column :games, :npc_last_move, :string
  end
end
