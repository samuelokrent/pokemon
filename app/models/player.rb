class Player < ApplicationRecord
  has_many :games
  has_many :pokemon_cards

  def has_full_deck?
    self.pokemon_cards.count >= Game.DECK_SIZE
  end
end
