class ChangeMegaToBool < ActiveRecord::Migration[6.0]
  def change
  	remove_column :pokemon_cards, :mega
    add_column :pokemon_cards, :mega, :boolean
  end
end
