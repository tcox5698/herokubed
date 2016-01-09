require 'herokubed/herokubed'

module Herokubed
  class LoadDumpLocally
    class << self
      def load_db(*args)
        if args.length != 2
          exit_with_error(USAGE_MESSAGE)
        end

        app_name, local_database = args[0], args[1]
        dump_file = ".dbwork/#{app_name}.dump"

        unless File.exists? dump_file
          exit_with_error(DUMP_FILE_MISSING_MESSAGE)
        end

        Herokubed.spawn_command "dropdb #{local_database}"
        Herokubed.spawn_command "createdb #{local_database}"

        pg_load_command = "pg_restore --verbose --clean --no-acl --no-owner -d #{local_database} #{dump_file}"
        Herokubed.spawn_command pg_load_command
      end

      def exit_with_error(message)
        puts message
        exit false
      end
    end
    DUMP_FILE_MISSING_MESSAGE = %q(
ERROR: dump file <#{dump_file} not found.

You can use kbackupdb to create and download the dump file for app #{app_name}.
  )

    USAGE_MESSAGE = %q(
Loads a postgres dump file from an heroku application
to a local postgres database. Assumes that kbackupdb
has been used successfully to create a .dbwork/<app_name>.dump file.
WARNING: overwrites the local database.

Usage: kloaddumplocally source_app_name target_local_database
)
  end
end