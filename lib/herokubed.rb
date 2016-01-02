require 'net/https'
require 'uri'
require 'json'

class Herokubed
  class << self

    def backup_db(*args)
      Dir.mkdir '.dbwork' unless Dir.exist? '.dbwork'

      app = args[0]

      db_backup_command = "heroku pg:backups capture --app #{app}"

      puts "DB BACKUP COMMAND: #{db_backup_command}"
      pid = spawn(db_backup_command)
      Process.wait pid


      backup_download_command = "curl -o .dbwork/#{app}.dump `heroku pg:backups public-url --app #{app}`"

      puts "BACKUP DOWNLOAD COMMAND: #{backup_download_command}"
      pid = spawn(backup_download_command)
      Process.wait pid
    end

    def transfer_db(*args)
      if args.length != 2
        puts MESSAGE_USAGE
        exit false
      end

      app_1 = args[0]
      app_2 = args[1]

      db_copy_command = "heroku pg:copy #{database_url(app_1)} DATABASE_URL --app #{app_2} --confirm #{app_2}"
      puts "DB COPY COMMAND: #{db_copy_command}"
      pid = spawn(db_copy_command)
      Process.wait pid
    end

    def database_url(app_name)
      config_url       = "https://api.heroku.com/apps/#{app_name}/config-vars"
      uri              = URI.parse(config_url)
      http             = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl     =true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE


      req                  = Net::HTTP::Get.new(uri.path)
      req["Accept"]        = "application/vnd.heroku+json; version=3"
      req["Authorization"] = "Bearer #{ENV['HEROKU_TOKEN']}"
      req["Content-Type"]  = "application/json"
      res                  = http.start do |http|
        http.request(req)
      end
      JSON.parse(res.body)['DATABASE_URL']
    end

    MESSAGE_USAGE = %q{
Transfers a postgres database from one heroku
application to another, overwriting the postgres
database of the second application.

Usage: ktransferdb source_app_name target_app_name
}
  end
end