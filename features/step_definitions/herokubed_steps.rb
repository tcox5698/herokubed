
Given(/^I have logged into heroku$/) do
  expect(call_heroku('GET', 'apps')).to include 'build_stack'
end


And(/^I have app '(.*)' with a postgres database$/) do |app_name|
  create_test_app env_app_name(app_name)
  expect(call_heroku('GET', 'apps')).to include "https://#{env_app_name(app_name)}.herokuapp.com"
end