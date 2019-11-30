class PokemonCard < ApplicationRecord
  belongs_to :pokemon_base
  belongs_to :player
  has_many :attacks
  delegate :type_one, to: :pokemon_base, allow_nil: true
  delegate :type_two, to: :pokemon_base, allow_nil: true
  delegate :image_path, to: :pokemon_base, allow_nil: true
  delegate :name, to: :pokemon_base, allow_nil: true
  before_create :initialize_health
  after_create :initialize_attacks

  MEGA_HP_MULTIPLIER = 1.3
  LOWER_BOUND_ATTACK_POWER = 0.25
  UPPER_BOUND_ATTACK_POWER = 0.35

  def hp
    self.mega ?
      (self.pokemon_base.hp * MEGA_HP_MULTIPLIER).to_i :
      self.pokemon_base.hp
  end

  def full_name
    self.mega ? "Mega #{self.name}" : self.name
  end

  def initialize_attacks
    attack_bases = AttackBase.where(attack_type: self.type_one).sample(2)
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

  def make_mega
    self.mega = true
    self.initialize_health
    self.save
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

  def active?
    self == self.player.active_card
  end

  def to_hash
    {
      id: self.id,
      player_id: self.player.id,
      name: self.full_name,
      type: self.type_one,
      hp: self.hp,
      health: self.health,
      alive: self.alive?,
      active: self.active?,
      attacks: self.attacks.map(&:to_hash),
      image: self.image_path,
    }
  end
end
