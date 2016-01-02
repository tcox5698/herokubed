
gem_file_name = `gem build herokubed.gemspec | grep -Eo 'File:(.*)$' | cut -c6-`
`gem install --no-ri --no-rdoc #{gem_file_name}`

After do
  delete_test_apps
  delete_local_test_dbs
  `rm -rf .dbwork`
end

