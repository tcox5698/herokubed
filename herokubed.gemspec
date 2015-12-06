Gem::Specification.new do |s|
  s.name        = 'herokubed'
  s.version     = '0.0.1'
  s.date        = '2015-12-05'
  s.summary     = 'Command line heroku convenience.'
  s.description = 'Herokubed provides simple command line heroku operations to do things like backup or transfer your postgres database.'
  s.authors     = ['Tom Cox']
  s.email       = 'tcox56_98@yahoo.com'
  s.files       = ['lib/herokubed.rb']
  s.homepage    =
      'http://rubygems.org/gems/hola'
  s.license       = 'Apache License version 2.0'
  s.executables = 'herokubed'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-expectations', '~> 3.4'
  s.add_development_dependency 'cucumber', '~> 2.1'
  s.add_development_dependency 'rake', '~> 10.4.2'
end