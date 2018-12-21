Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'solidus_delivery_options'
  s.version = '2.2.12'
  s.summary = 'Adds delivery date and time during checkout'
  s.description = ''
  s.required_ruby_version = '>= 2.0.0'

  s.author = 'Francisco Trindade'
  s.email = 'frank.trindade@gmail.com'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', '>= 1.0.0', '< 3'
  s.add_dependency 'solidus_support'
  s.add_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'
end
