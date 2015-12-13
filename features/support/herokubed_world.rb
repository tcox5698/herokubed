require 'JSON'

module HerokubedWorld
  def call_heroku(http_method, api_call, data = nil)
    expect(`echo $HEROKU_TOKEN`.chomp).not_to be_empty, 'Must supply HEROKU_TOKEN as environment variable.'
    curl_command = %Q(curl -s -X #{http_method} https://api.heroku.com/#{api_call} -H "Accept: application/vnd.heroku+json; version=3" -H "Authorization: Bearer $HEROKU_TOKEN" -H "Content-Type: application/json" #{data_string(data)})
    `#{curl_command}`
  end

  def data_string(data)
    (data and " -d '#{data.to_json}'") or ''
  end

  def register_test_app(app_name)
    @test_app_names ||= []
    @test_app_names << app_name
  end

  def create_test_app test_app_name
    register_test_app test_app_name

    expect(call_heroku('POST', 'apps', {'name' => test_app_name})).to include test_app_name
    puts "created app #{test_app_name}"
  end

  def delete_test_apps
    @test_app_names.each do |test_app_name|

      expect(`heroku apps:destroy -a #{test_app_name} --confirm #{test_app_name}`.chomp).to include 'Destroying'
      puts "deleted app: #{test_app_name}"
    end
  end

  def current_apps
    call_heroku('GET', 'apps')
  end

  def env_app_name(app_name)
    "#{app_name}-#{`whoami`.chomp}"
  end
end

World(HerokubedWorld)