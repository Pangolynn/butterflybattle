class CreateHighscores < ActiveRecord::Migration
  def change
    create_table :highscores do |t|
      t.integer :p_score
      t.string :p_name
      t.integer :level
      t.string :date

      t.timestamps
    end
  end
end
