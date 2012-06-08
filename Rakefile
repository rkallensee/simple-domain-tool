task :environment do
  require 'environment'
end


desc "Run those specs"
task :spec do
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = ['--colour', '--format progress'] # , '-r ./spec/spec_helper.rb'
    t.pattern = 'spec/**/*_spec.rb'
  end
end