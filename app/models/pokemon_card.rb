class PokemonCard < ApplicationRecord
	belongs_to :pokemon_base
	belongs_to :player
end
