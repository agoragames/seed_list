class Tournament < ActiveRecord::Base
  has_many :players
  seed :players
end
