class Herokubed
  class << self

    def ktransferdb(*args)
      STDERR.puts "YABBA: #{args}"

      if args.length != 2
        puts MESSAGE_USAGE
        exit false
      end

      pid = spawn("heroku pg:copy #{args[0]} --app #{args[1]}")
      Process.wait pid
    end
  end

  MESSAGE_USAGE = %q{
Transfers a postgres database from one heroku
application to another, overwriting the postgres
database of the second application.

Usage: ktransferdb source_app_name target_app_name
}

end