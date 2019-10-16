class PokemonCard < ApplicationRecord
	belongs_to :pokemon
	belongs_to :player
end
