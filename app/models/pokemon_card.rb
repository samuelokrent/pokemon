class PokemonCard < ApplicationRecord
  belongs_to :pokemon_base
  belongs_to :player
  belongs_to :attack_one, class_name: 'Attack', foreign_key: 'attack_one_id'
  belongs_to :attack_two, class_name: 'Attack', foreign_key: 'attack_two_id'
  has_many :attacks
  delegate :type_one, to: :pokemon_base, allow_nil: true
  delegate :type_two, to: :pokemon_base, allow_nil: true
  before_create :initialize_attacks, :initialize_health

  MEGA_HP_MULTIPLIER = 1.3
  LOWER_BOUND_ATTACK_POWER = 0.25
  UPPER_BOUND_ATTACK_POWER = 0.35

  def hp
    self.mega ?
      (self.pokemon_base.hp * MEGA_HP_MULTIPLIER).to_i :
      self.pokemon_base.hp
  end

  def initialize_attacks
    attack_bases = AttackBase.where(type: self.type_one).sample(2)
    attack_bases.each do |ab|
      Attack.create(pokemon_card: self, attack_base: ab, power: rand(self.attack_power_range))
    end
  end

  def initialize_health
    self.health = self.hp
  end

  def attack_power_range
    lower = (LOWER_BOUND_ATTACK_POWER * self.hp).to_i
    upper = (UPPER_BOUND_ATTACK_POWER * self.hp).to_i
    (lower..upper)
  end

  def apply_damage(damage)
    self.update_attribute(:health, [0, self.health - damage].max)
  end

  def apply_healing(amount)
    self.update_attribute(:health, [self.hp, self.health + amount].min)
  end

  def alive?
    self.health > 0
  end
end
