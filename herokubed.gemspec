Gem::Specification.new do |s|
  s.name        = 'herokubed'
  s.version     = '0.0.5'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Command line heroku convenience.'
  s.description = 'Herokubed provides simple command line heroku operations to do things like backup or transfer your postgres database.'
  s.authors     = ['Tom Cox']
  s.email       = 'tcox56_98@yahoo.com'
  s.files       = [
      'lib/herokubed.rb',
      'lib/herokubed_backup.rb',
      'lib/herokubed_transfer.rb'
  ]
  s.homepage    = 'https://github.com/tcox5698/herokubed'
  s.license     = 'Apache-2.0'
  s.executables = ['ktransferdb', 'kbackupdb']
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-expectations', '~> 3.4'
  s.add_development_dependency 'cucumber', '~> 2.1'
  s.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_development_dependency 'pg', '~> 0.18', '>= 0.18.4'
end