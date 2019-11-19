class Game < ApplicationRecord
  belongs_to :player_one, class_name: 'Player', foreign_key: 'player_one_id'
  belongs_to :player_two, class_name: 'Player', foreign_key: 'player_two_id'

  accepts_nested_attributes_for :player_one
  accepts_nested_attributes_for :player_two

  def self.DECK_SIZE
    6
  end

  def decks_full?
    self.player_one.has_full_deck? and self.player_two.has_full_deck?
  end

  def update_state
    new_state = case self.state
    when "new"
      if self.player_one_id.present? and self.player_two_id.present?
        "building_decks"
      end
    when "building_decks"
      if self.decks_full?
        "battle"
      end
    end
    if new_state and new_state != self.state
      self.update_attributes(state: new_state, turn: 1)
    end
  end

  def advance_turn
    self.update_attribute(:turn, 3 - self.turn)
  end
end
