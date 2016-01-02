require 'herokubed'

module Herokubed

  class Backup
    class << self
      def backup_db(*args)
        if args.length != 1
          puts MESSAGE_USAGE
          exit false
        end

        app = args[0]
        Dir.mkdir '.dbwork' unless Dir.exists? '.dbwork'

        db_backup_command = "heroku pg:backups capture --app #{app}"
        Herokubed.spawn_command(db_backup_command)

        backup_download_command = "curl -o .dbwork/#{app}.dump `heroku pg:backups public-url --app #{app}`"
        Herokubed.spawn_command(backup_download_command)
      end

      MESSAGE_USAGE = %q(
Creates a dump file of a postgres database from an heroku
application, and downloads that file to .dbwork/<app_name>.dump.
If there is an existing .dbwork/<app_name>.dump file, that file will
be renamed to .dbwork/<app_name>.dump.<create_date>

Usage: kbackupdb source_app_name
)
    end
  end
end