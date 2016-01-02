require 'herokubed'

module Herokubed

  class Backup
    class << self
      def backup_db(*args)
        app = args[0]
        Dir.mkdir '.dbwork' unless Dir.exist? '.dbwork'

        db_backup_command = "heroku pg:backups capture --app #{app}"
        Herokubed.spawn_command(db_backup_command)

        backup_download_command = "curl -o .dbwork/#{app}.dump `heroku pg:backups public-url --app #{app}`"
        Herokubed.spawn_command(backup_download_command)
      end
    end
  end
end