class Game < ApplicationRecord
  belongs_to :player_one, class_name: 'Player', foreign_key: 'player_one_id'
  belongs_to :player_two, class_name: 'Player', foreign_key: 'player_two_id'

  accepts_nested_attributes_for :player_one
  accepts_nested_attributes_for :player_two

  def self.DECK_SIZE
    6
  end
end
