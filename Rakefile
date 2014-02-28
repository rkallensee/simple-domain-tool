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

# CSS compilation tasks.
namespace :styles do
  compass_root = "./"

  desc "Run compass stats"
  task :stats do
    puts "*** Running compass stats ***"
    system "bundle exec compass stats " + compass_root
  end

  desc "Clean all compiled CSS files as well as the Sass cache"
  task :clean do
    puts "*** Cleaning styles and Sass cache ***"
	system "bundle exec compass clean " + compass_root
  end

  desc "Watch the styles and compile new changes"
  task :watch => ["watch:default"]

  namespace :watch do
    desc "Watch styles and compile with development settings"
    task :default => :clean do
      puts "*** Watching styles with development settings ***"
      system "bundle exec compass watch -e development " + compass_root
    end

    desc "Watch styles and compile with production settings"
    task :production => :clean do
      puts "*** Watching styles with production settings ***"
      system "bundle exec compass watch -e production " + compass_root
    end
  end

  desc "Compile new styles"
  task :compile => ["compile:default"]

  namespace :compile do
    desc "Compile styles for development"
    task :default => :clean do
      puts "*** Compiling styles ***"
      system "bundle exec compass compile -e development --debug-info " + compass_root
    end

    desc "Compile styles for production"
    task :production => :clean do
      puts "*** Compiling styles ***"
      system "bundle exec compass compile -e production --force " + compass_root
    end
  end
end