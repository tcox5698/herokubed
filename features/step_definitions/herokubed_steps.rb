require 'pg'

Given(/^I have logged into heroku$/) do
  expect(call_heroku('GET', 'apps')).to include 'build_stack'
end


And(/^I have app '(.*)' with a postgres database$/) do |app_name|
  create_test_app env_app_name(app_name)
  expect(call_heroku('GET', 'apps')).to include "https://#{env_app_name(app_name)}.herokuapp.com"

  add_postgres_addon(env_app_name(app_name))
end

And(/^I add table '(.*)' to app '(.*)' with the following records$/) do |table_name, app_name, table|
  columns = table.hashes.first.keys
  columns_strings = columns.map{|original| "#{original} integer"}
  columns_string = columns_strings.join(', ')

  database_url = JSON.parse(call_heroku('GET', "apps/#{env_app_name(app_name)}/config-vars"))['DATABASE_URL']
  conn = PG.connect(database_url)
  conn.exec("CREATE TABLE #{table_name} (#{columns_string});")


  conn.exec("INSERT INTO #{table_name} (#{columns.join(',')}) values (1234);")

  conn.exec("SELECT * FROM #{table_name}") do |result|
    result.each do |row|
      expect(row['id']).to eq '1234'
    end
  end

  conn.close
end
