class PokemonBase < ApplicationRecord

  def image_path
    "pokemon/#{self.image}"
  end

end
