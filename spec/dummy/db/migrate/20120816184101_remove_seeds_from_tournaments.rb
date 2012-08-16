class RemoveSeedsFromTournaments < ActiveRecord::Migration
  def up
    remove_column :tournaments, :seeds
  end

  def down
    add_column :tournaments, :seeds, :text
  end
end
