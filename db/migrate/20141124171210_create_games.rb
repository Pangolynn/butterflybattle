class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :userID
      t.string :pName
      t.integer :pHealth
      t.integer :pDefense

      t.timestamps
    end
  end
end
