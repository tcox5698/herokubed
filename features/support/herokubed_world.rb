require 'json'
require 'pg'

module HerokubedWorld
  def spawn_command(command_string)
    puts "STEP: executing: #{command_string} in directory #{`pwd`}"
    #/home/vagrant/.rvm/gems/ruby-2.2.1/bin:/home/vagrant/.rvm/gems/ruby-2.2.1@global/bin:/home/vagrant/.rvm/rubies/ruby-2.2.1/bin:/usr/local/heroku/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vagrant/.rvm/bin
    env     = {
        'PATH' => '/home/vagrant/.rvm/gems/ruby-2.2.1/bin:/home/vagrant/.rvm/rubies/ruby-2.2.1/bin:/usr/bin',
        'HOME' => ENV['HOME'],
        'HEROKU_TOKEN' => ENV['HEROKU_TOKEN'],
        'HEROKU_USERNAME' => ENV['HEROKU_USERNAME']
    }
    options = { unsetenv_others: true }

    spawn(env, "echo $PATH", options)
    pid = spawn(env, command_string, options)

    Process.wait pid
    puts "STEP: completed: #{command_string}"
  end

  def restore_dump_file(dump_file, local_db)
    restore_command = "pg_restore --verbose --clean --no-acl --no-owner -d #{local_db} #{dump_file}"
    puts "RESTORE COMMAND: #{restore_command}"

    spawn_command(restore_command)
  end

  def delete_local_test_dbs
    if @test_local_dbs
      @test_local_dbs.each do |local_db|
        spawn_command("dropdb #{local_db}")
      end
    end
  end

  def create_local_db(local_db_name)
    register_local_db local_db_name
    spawn_command("createdb #{local_db_name}")
  end

  def register_local_db(local_db_name)
    @test_local_dbs ||= []
    @test_local_dbs << local_db_name
  end

  def add_postgres_addon app_name
    data     = { 'plan' => 'heroku-postgresql:hobby-dev' }
    response = call_heroku('POST', "apps/#{app_name}/addons", data)
    expect(response).to include 'heroku-postgresql:hobby-dev'
  end

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

    expect(call_heroku('POST', 'apps', { 'name' => test_app_name })).to include test_app_name
  end

  def delete_test_apps
    if @test_app_names
      @test_app_names.each do |test_app_name|
        expect(call_heroku('DELETE', "apps/#{test_app_name}")).to include 'released_at'
      end

      current_app_names = current_apps.map { |app_json| app_json['name'] }
      expect(current_app_names - @test_app_names).to eq (current_app_names)
    end
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

  def with_heroku_db(app_name)
    database_url = JSON.parse(call_heroku('GET', "apps/#{env_app_name(app_name)}/config-vars"))['DATABASE_URL']
    conn         = PG.connect(database_url)
    yield conn
    conn.close
  end

  def with_local_db(local_db)
    conn = PG.connect(dbname: local_db)
    yield conn
    conn.close
  end

  def setup_heroku_credentials
    netrc = File.join(ENV['HOME'], '.netrc')
    unless File.exists?(netrc)
      unless ENV['HEROKU_USERNAME']
        raise 'Environment variable HEROKU_USERNAME is required.'
      end

      unless ENV['HEROKU_TOKEN']
        raise 'Environment variable HEROKU_TOKEN is required.'
      end

      File.open(netrc, 'w') do |f|
        f.puts %Q(
machine api.heroku.com
  login #{ENV['HEROKU_USERNAME']}
  password #{ENV['HEROKU_TOKEN']}
               )
      end
      `chmod 0600 /home/vagrant/.netrc`
    end
  end
end

World(HerokubedWorld)