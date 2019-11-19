class AddGameFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :state
    add_column :games, :state, :string, default: "new"
    add_column :games, :turn, :integer, default: 1
    add_column :pokemon_cards, :health, :integer
    add_column :pokemon_cards, :attack_one_id, :integer
    add_column :pokemon_cards, :attack_two_id, :integer
    create_table :attack_bases do |t|
      t.string :name
      t.string :type
    end
    create_table :attacks do |t|
      t.integer :attack_base_id
      t.integer :pokemon_card_id
      t.integer :power
    end
  end
end
