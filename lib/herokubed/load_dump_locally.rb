require 'herokubed/herokubed'
require 'fileutils'

module Herokubed
  class LoadDumpLocally
    class << self
      def load(*args)
        if args.length != 2
          puts USAGE_MESSAGE
          exit false
        end

        app_name, local_database = args[0], args[1]
        dump_file = ".dbwork/#{app_name}.dump"

        Herokubed.spawn_command "dropdb #{local_database}"
        Herokubed.spawn_command "createdb #{local_database}"

        pg_load_command = "pg_restore --verbose --clean --no-acl --no-owner -d #{local_database} #{dump_file}"
        Herokubed.spawn_command pg_load_command
      end
    end
  end

  USAGE_MESSAGE = %q(
Loads a postgres dump file from an heroku application
to a local postgres database. Assumes that kbackupdb
has been used successfully to create a .dbwork/<app_name>.dump file.
WARNING: overwrites the local database.

Usage: kloaddumplocally source_app_name target_local_database
)
end