class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_bases do |t|
      t.string :name
      t.string :type_one
      t.string :type_two
      t.integer :hp
      t.string :image
      t.timestamps
    end

    create_table :pokemon_cards do |t|
      t.integer :pokemon_id
      t.integer :mega
    end
  end
end
