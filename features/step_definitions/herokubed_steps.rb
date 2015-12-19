Given(/^I have logged into heroku$/) do
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

Then(/^app '(.*)' has a table '(.*)' with a records with value '(.*)'$/) do |app_name, expected_table, expected_value|
  with_db(app_name) do |conn|
    conn.exec("SELECT * FROM #{expected_table}") do |result|
      expect(result.first['name']).to eq expected_value
    end
  end
end

When(/^I successfully execute '(.*)'$/) do |command|
  puts "STEP: executing: #{command}"
  pid = spawn(command)
  Process.wait pid
  puts "STEP: completed: #{command}"

end