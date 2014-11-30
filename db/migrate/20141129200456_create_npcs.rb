class CreateNpcs < ActiveRecord::Migration
  def change
    create_table :npcs do |t|
      t.integer :level
      t.integer :npc_max_health
      t.integer :npc_cur_health
      t.integer :npc_max_speed
      t.integer :npc_cur_speed
      t.integer :npc_max_armor
      t.integer :npc_cur_armor
      t.integer :npc_max_attack
      t.integer :npc_cur_attack
      t.string :npc_file
      t.string :npc_name
      t.string :npc_wild
      t.string :npc_offense
      t.string :npc_defense

      t.timestamps
    end
  end
end
