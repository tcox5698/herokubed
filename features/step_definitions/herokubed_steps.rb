
Given(/^I have logged into heroku$/) do
  expect(call_heroku('GET', 'apps')).to include 'build_stack'
end


And(/^I have app '(.*)' with a postgres database$/) do |app_name|
  unique_app_name = generate_env_app_name(app_name)
  create_test_app unique_app_name
  expect(call_heroku('GET', 'apps')).to include "https://#{unique_app_name}.herokuapp.com"

  add_postgres_addon(unique_app_name)
end