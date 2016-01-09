require 'herokubed/herokubed'
require 'fileutils'

module Herokubed
  class LoadDumpLocally
    class << self
      def load(*args)
        app_name, local_database = args[0], args[1]
        dump_file = ".dbwork/#{app_name}.dump"

        Herokubed.spawn_command "dropdb #{local_database}"
        Herokubed.spawn_command "createdb #{local_database}"

        pg_load_command = "pg_restore --verbose --clean --no-acl --no-owner -d #{local_database} #{dump_file}"
        Herokubed.spawn_command pg_load_command
      end
    end
  end
end