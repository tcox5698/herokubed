
Given(/^I have logged into heroku$/) do
  expect(`echo $HEROKU_TOKEN`.chomp).not_to be_empty, 'Must supply HEROKU_TOKEN as environment variable.'
  expect(`curl -X GET https://api.heroku.com/apps -H "Accept: application/vnd.heroku+json; version=3" -H "Authorization: Bearer $HEROKU_TOKEN"`).to include 'build_stack'
end

And(/^I have app '(.*)' with a postgres database$/) do |app_name|
  create_test_app app_name
  expect(`curl -X GET https://api.heroku.com/apps -H "Accept: application/vnd.heroku+json; version=3" -H "Authorization: Bearer $HEROKU_TOKEN"`).to include "https://kubedapp1.herokuapp.com"
end