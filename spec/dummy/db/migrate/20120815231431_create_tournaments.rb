class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.text :seeds
    end
  end
end
