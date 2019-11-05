class PokemonCard < ApplicationRecord
  belongs_to :pokemon_base
  belongs_to :player

  MEGA_HP_MULTIPLIER = 1.3

  def real_hp
    self.mega ?
      (self.pokemon_base.hp * MEGA_HP_MULTIPLIER).to_i :
      self.pokemon_base.hp
  end
end
