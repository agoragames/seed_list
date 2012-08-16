class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :tournament
    end
  end
end
