Before do
  @apps_before = current_apps
end



After do
  delete_test_apps

  unless @apps_before == current_apps
    puts "Failed to delete test heroku apps:\n #{current_apps}"
    raise "Failed to delete test heroku apps:\n #{current_apps}"
  end

  puts "must have deleted all the test apps okay"
end

