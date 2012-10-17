require 'seed_list/version'
require 'seed_list/list'
require 'seed_list/association'
require 'seed_list/strategy'
require 'seed_list/cli'

module SeedList
  mattr_accessor :tournament_class_name, :player_class_name
end
