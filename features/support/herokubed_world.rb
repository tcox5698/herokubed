require 'json'
require 'pg'

module HerokubedWorld
  def add_postgres_addon app_name
    data = {'plan' => 'heroku-postgresql:hobby-dev'}
    response = call_heroku('POST', "apps/#{app_name}/addons", data)
    expect(response).to include 'heroku-postgresql:hobby-dev'
  end

  def call_heroku(http_method, api_call, data = nil)
    expect(`echo $HEROKU_TOKEN`.chomp).not_to be_empty, 'Must supply HEROKU_TOKEN as environment variable.'
    curl_command = %Q(curl -s -X #{http_method} https://api.heroku.com/#{api_call} -H "Accept: application/vnd.heroku+json; version=3" -H "Authorization: Bearer $HEROKU_TOKEN" -H "Content-Type: application/json" #{data_string(data)})
    puts "CURL COMMAND:\n#{curl_command}"
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
      expect(call_heroku('DELETE', "apps/#{test_app_name}")).to include 'released_at'
      puts "deleted app: #{test_app_name}"
    end

    current_app_names = current_apps.map{|app_json|app_json['name']}
    expect(current_app_names - @test_app_names).to eq (current_app_names)
  end

  def current_apps
    JSON.parse(call_heroku('GET', 'apps'))
  end

  def env_app_name(app_name)
    @mapped_app_names ||= {}
    unless @mapped_app_names[app_name]
      @mapped_app_names[app_name] = "#{app_name}-#{`whoami`.chomp}-#{Time.now.strftime('%L')}"
    end
    @mapped_app_names[app_name]
  end

  def with_db(app_name)
    database_url = JSON.parse(call_heroku('GET', "apps/#{env_app_name(app_name)}/config-vars"))['DATABASE_URL']
    conn = PG.connect(database_url)
    yield conn
    conn.close
  end
end

World(HerokubedWorld)