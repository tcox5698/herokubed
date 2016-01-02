require 'net/https'
require 'uri'
require 'json'

module Herokubed
  class << self
    def spawn_command(command_string)
      puts "executing: #{command_string}"
      pid = spawn(command_string)
      Process.wait pid
      puts "completed: #{command_string}"
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


  end
end