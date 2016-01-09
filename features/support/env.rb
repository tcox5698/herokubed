puts 'CUCUMBER - uninstalling herokubed gem'
`gem uninstall -i /home/vagrant/.rvm/gems/ruby-2.2.1@global herokubed -a -x`
puts 'CUCUMBER - building herokubed gem'
gem_file_name = `gem build herokubed.gemspec | grep -Eo 'File:(.*)$' | cut -c6-`
puts 'CUCUMBER - installing herokubed gem'
`gem install --no-ri --no-rdoc #{gem_file_name}`
puts 'CUCUMBER - building and installing herokubed gem - FINISHED'

Before do
  Dir.chdir '/tmp'
end

After do
  delete_test_apps
  delete_local_test_dbs
  Dir.chdir '..'
  `rm -rf /tmp/.dbwork`
end

