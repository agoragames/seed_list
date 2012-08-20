$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'seed_list/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'seed_list'
  s.version     = SeedList::VERSION
  s.authors     = ['TODO: Your name']
  s.email       = ['TODO: Your email']
  s.homepage    = 'TODO'
  s.summary     = 'TODO: Summary of SeedList.'
  s.description = 'TODO: Description of SeedList.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 3.2.6'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry-rails'
end
