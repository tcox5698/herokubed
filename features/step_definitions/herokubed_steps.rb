Given(/^I have logged into heroku$/) do
  setup_heroku_credentials

  expect(call_heroku('GET', 'apps')).to include 'build_stack'
end

And(/^I have app '(.*)' with a postgres database$/) do |app_name|
  create_test_app env_app_name(app_name)
  expect(call_heroku('GET', 'apps')).to include "https://#{env_app_name(app_name)}.herokuapp.com"

  add_postgres_addon(env_app_name(app_name))
end

And(/^I add table '(.*)' to app '(.*)' with a record with value '(.*)'$/) do |table_name, app_name, insert_value|
  with_db(app_name) do |conn|
    conn.exec("CREATE TABLE #{table_name} (name varchar(100));")
    conn.exec("INSERT INTO #{table_name} (name) values ('#{insert_value}');")
  end
end

Then(/^app '(.*)' has a table '(.*)' with a record with value '(.*)'$/) do |app_name, expected_table, expected_value|
  with_db(app_name) do |conn|
    conn.exec("SELECT * FROM #{expected_table}") do |result|
      expect(result.first['name']).to eq expected_value
    end
  end
end

When(/^I successfully execute '(.*)'$/) do |command|
  puts "STEP: executing: #{command}"
  command_array = command.split(' ')
  command_array[1] = env_app_name(command_array[1])
  command_array[2] = env_app_name(command_array[2])
  pid = spawn(command_array.join(' '))
  Process.wait pid
  puts "STEP: completed: #{command}"
end

Given(/^herokubed is built and installed$/) do
  gem_file_name = ` gem build herokubed.gemspec | grep -Eo 'File:(.*)$' | cut -c6-`
  expect(gem_file_name).to match /herokubed-.*\.gem/
  install_output = ` gem install --no-ri --no-rdoc #{gem_file_name}`
    expect(install_output).to match /Successfully installed herokubed-.*/
  end

  Then(/^I get addon info for app '(.*)' addon '(.*)'$/) do |app_name, addon_name|
    puts call_heroku('GET', "apps/#{env_app_name(app_name)}/config-vars")
  end

  Given(/^heroku toolbelt is installed$/) do
    unless `which heroku`.include? 'heroku'
      `wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh`
    end
  end