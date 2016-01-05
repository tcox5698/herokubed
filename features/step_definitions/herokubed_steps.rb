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
  with_heroku_db(app_name) do |conn|
    conn.exec("CREATE TABLE #{table_name} (name varchar(100));")
    conn.exec("INSERT INTO #{table_name} (name) values ('#{insert_value}');")
  end
end

Then(/^app '(.*)' has a table '(.*)' with a record with value '(.*)'$/) do |app_name, expected_table, expected_value|
  with_heroku_db(app_name) do |conn|
    conn.exec("SELECT * FROM #{expected_table}") do |result|
      expect(result.first['name']).to eq expected_value
    end
  end
end

When(/^I successfully execute kbackupdb for app '(.*)'$/) do |app_name|
  command_string = "kbackupdb #{env_app_name(app_name)}"
  spawn_command(command_string)
end

When(/^I successfully execute ktransferdb from app '(.*)' to app '(.*)'$/) do |app_name_1, app_name_2|
  spawn_command("ktransferdb #{env_app_name(app_name_1)} #{env_app_name(app_name_2)}")
end

Then(/^I get addon info for app '(.*)' addon '(.*)'$/) do |app_name, addon_name|
  call_heroku('GET', "apps/#{env_app_name(app_name)}/config-vars")
end

Given(/^heroku toolbelt is installed$/) do
  unless `which heroku`.include? 'heroku'
    `wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh`
  end
end

Then(/^I have a new dump file in the \.dbwork directory for app '(.*)'$/) do |app_name|
  expect(File.mtime(".dbwork/#{env_app_name(app_name)}.dump")).to be > (Time.now - 300)
end

When(/^I load the \.dbwork dump file for app '(.*)' into local db '(.*)'$/) do |app_name, local_db_name|
  create_local_db local_db_name
  dump_file = Dir[".dbwork/*#{env_app_name(app_name)}.dump"][0]
  restore_dump_file dump_file, local_db_name
end

Then(/^local db '(.*)' has a table '(.*)' with a record with value '(.*)'$/) do |local_db, expected_table, expected_value|
  with_local_db(local_db) do |conn|
    conn.exec("SELECT * FROM #{expected_table}") do |result|
      expect(result.first['name']).to eq expected_value
    end
  end
end

Given(/^I have a dump file for app '(.*)' in the \.dbwork directory last modified at '(.*)'$/) do |app_name, modified_time_string|
  Dir.mkdir('.dbwork') unless File.exists?('.dbwork')
  dump_file_name = "#{env_app_name(app_name)}.dump"
  `touch -m -t #{modified_time_string} .dbwork/#{dump_file_name}`
end

And(/^there is a dump file for app '(.*)' in the \.dbwork directory postfixed with '(.*)'$/) do |app_name, expected_date_postfix|
  expected_file_name = ".dbwork/#{env_app_name(app_name)}.dump.#{expected_date_postfix}"
  actual_file_name   = Dir[expected_file_name][0]
  expect(actual_file_name).to match /#{expected_file_name}/
end

