class AddPlayerIdToPokemonCards < ActiveRecord::Migration[6.0]
  def change
    add_column :pokemon_cards, :player_id
  end
end
