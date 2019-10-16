class AddPlayerBaseIdToPokemonCards < ActiveRecord::Migration[6.0]
  def change
  	remove_column :pokemon_cards, :pokemon_id
    add_column :pokemon_cards, :pokemon_base_id, :integer
  end
end
