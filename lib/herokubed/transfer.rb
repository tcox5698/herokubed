require 'herokubed/herokubed'

module Herokubed
  class Transfer
    class << self
      def transfer_db(*args)
        if args.length != 2
          puts USAGE_MESSAGE
          exit false
        end

        app_1, app_2 = args[0], args[1]

        db_copy_command = "heroku pg:copy #{Herokubed.database_url(app_1)} DATABASE_URL --app #{app_2} --confirm #{app_2}"
        Herokubed.spawn_command(db_copy_command)
      end

      USAGE_MESSAGE = %q{
Transfers a postgres database from one heroku
application to another, overwriting the postgres
database of the second application.

Usage: ktransferdb source_app_name target_app_name
}
    end
  end
end