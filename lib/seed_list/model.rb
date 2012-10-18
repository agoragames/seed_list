module SeedList
  class Model < ActiveRecord::Base
    self.table_name = 'seed_lists'
    serialize :list, SeedList::List
    belongs_to :tournament, polymorphic: true
    delegate :move, :unshift, :push, :delete, :find, :to => :list
  end
end
