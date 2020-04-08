class AddActiveCardIdToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :active_card_id, :integer
  end
end
