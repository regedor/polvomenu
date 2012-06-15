require 'rspec/core/rake_task'
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "polvo/menu/version"

RSpec::Core::RakeTask.new('spec')

desc "Load development gem and starts IRB"
task :console do
  exec 'irb -I lib -r polvomenu.rb'
end

desc "Deletes built gem files"
task :clean do
  system "rm -f polvomenu-*.gem"
end

task :build => :clean  do
  system "gem build polvomenu.gemspec"
end

desc "Cleans all the gem files, creates a new one, push it to rubygems and installs it "
task :release => :build do
  puts "Tagging #{Polvo::Menu::VERSION}..."
  system "git tag -a #{Polvo::Menu::VERSION} -m 'Tagging #{Polvo::Menu::VERSION}'"
  puts "Pushing to Github..."
  system "git push --tags"
  puts "Pushing to rubygems.org..."
  system "gem push rails_best_practices-#{Polvo::Menu::VERSION}.gem"
end

namespace :install do
  
  task :local => :build do
    system "gem uninstall -x polvomenu"   
    system "gem install polvomenu-#{Polvo::Menu::VERSION}.gem"
  end
  
  desc "Cleans all the gem files, creates a new one, installs it "
  task :remote do
    `rm polvomenu-*.gem `
    `gem build polvomenu.gemspec`
    `gem uninstall polvomenu`
    `gem install polvomenu-*.gem`
  end
  
end


task :default do 
  puts `rake -T`
end

task :test => :spec

