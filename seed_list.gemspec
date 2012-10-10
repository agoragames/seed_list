$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'seed_list/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'seed_list'
  s.version     = SeedList::VERSION
  s.authors     = ['Logan Koester']
  s.email       = ['lkoester@majorleaguegaming.com']
  s.homepage    = 'https://github.com/agoragames/seed_list'
  s.summary     = 'Seed management for tournament brackets'
  s.description = 'SeedList is designed for Rails-powered tournament engines that need to persist a 1-indexed ordered list of players (ranked low-to-high by skill or past performance) and then match them up appropriately in the first round of a bracket.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 3.2.6'
  s.add_dependency 'thor'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry-rails'
end
