require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'cucumber'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => [:spec, :features]