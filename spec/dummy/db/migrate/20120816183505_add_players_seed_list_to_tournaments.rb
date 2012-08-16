class AddPlayersSeedListToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :players_seed_list, :text
  end
end
