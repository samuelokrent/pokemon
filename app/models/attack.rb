class Attack < ApplicationRecord
  belongs_to :pokemon_card
  belongs_to :attack_base
  delegate :name, to: :attack_base, allow_nil: true

  SUPER_EFFECTIVE_MULTIPLIER = 1.3

  def damage(super_effective)
    multiplier = super_effective ? SUPER_EFFECTIVE_MULTIPLIER : 1
    self.power * multiplier
  end
end
