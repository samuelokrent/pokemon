class Player < ApplicationRecord
  has_many :games
  has_many :pokemon_cards

  def has_full_deck?
    self.pokemon_cards.count >= Game.DECK_SIZE
  end

  def student?
  	self.player_type == "student"
  end

  def active_card
  	self.pokemon_cards.select(&:alive?).first?
  end

  def defeated?
  	self.pokemon_cards.select { |c| !c.alive? }.count == Game.DECK_SIZE
  end

  def to_hash
  	id: self.id,
  	deck: self.pokemon_cards.map(&:to_hash),
  	active_card: self.active_card.to_hash,
  	student: self.student?,
  end
end
