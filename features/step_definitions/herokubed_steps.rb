


Given(/^I have logged into heroku$/) do
  expect(call_heroku('GET', 'apps')).to include 'build_stack'
end

And(/^I have app '(.*)' with a postgres database$/) do |app_name|
  create_test_app app_name
  expect(call_heroku('GET', 'apps')).to include "https://kubedapp1.herokuapp.com"
end