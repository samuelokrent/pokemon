class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :player_one_id
      t.integer :plaer_two_id
      t.string :state
      t.timestamps
    end
  end
end
