def test_app_names
  @test_app_names ||= []
end

def create_test_app test_app_name
  puts "creating app #{test_app_name}"
  test_app_names << test_app_name
  curl_command = %Q( curl -X POST https://api.heroku.com/apps -H "Accept: application/vnd.heroku+json; version=3" -H "Authorization: Bearer $HEROKU_TOKEN" -H "Content-Type: application/json"  -d '{"name": "#{test_app_name}"}' )
  puts "curl command: #{curl_command}"
  expect(`#{curl_command}`.chomp).to include test_app_name
  puts 'done creating app'
end

Before do
  puts 'IM BEFORE'
end

After do
  test_app_names.each do |test_app_name|
    puts "deleted app: #{test_app_name}"
    expect(`heroku apps:destroy -a #{test_app_name} --confirm #{test_app_name}`.chomp).to eq ''
  end
end