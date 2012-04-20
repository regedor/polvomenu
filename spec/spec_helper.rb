require 'simplecov'
SimpleCov.start
require 'rubygems'
require 'bundler/setup'

require 'rspec/mocks/standalone'
require 'polvomenu' 

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.run_all_when_everything_filtered = true
  c.filter_run :focus
end

def fixtures_folder(string_path, options={})
  path = string_path.split("/")
  last = path.pop if options[:single]
  
  rootdirs = [ 
    {'rootdir1' => [
      {'dir1' => [
        {'dirb1.1' => [], :items_for_parent => {:title=>"dir1.1", :type=>"dir", :path=>"dir1/dir1.1", :rootdir=>"spec/fixtures/rootdir1"}}, 
        {'dirc1.2' => [], :items_for_parent => {:title=>"dir1.2", :type=>"dir", :path=>"dir1/dir1.2", :rootdir=>"spec/fixtures/rootdir1"}}        
      ], :items_for_parent => { :title=>"dir1", :type=>"dir", :path=>"./dir1", :rootdir=>"spec/fixtures/rootdir1" }}, 
      {'dir2' => [], :items_for_parent => { :title=>"dir2", :type=>"dir", :path=>"./dir2", :rootdir=>"spec/fixtures/rootdir1" }}, 
      {'dir3' => [], :items_for_parent => { :title=>"This is an exec.bash inside rootdir1/dir3", :priority=>0,:os=>"ubuntu", :type=>"script", :path=>"./dir3/exec.bash", :rootdir=>"spec/fixtures/rootdir1" }}
    ], :items_for_parent => { :title=>"dir1", :type=>"dir", :path=>"./dir1", :rootdir=>"spec/fixtures/rootdir1" }},
    {'rootdir2' => [
      {'dir1' => [], :items_for_parent => {:title=>"dir1", :type=>"dir", :path=>"./dir1", :rootdir=>"spec/fixtures/rootdir2"}},
      {'dir2' => [], :items_for_parent => {:title=>"dir2", :type=>"dir", :path=>"./dir2", :rootdir=>"spec/fixtures/rootdir2"}}, 
      {'dir4' => [], :items_for_parent => {:title=>"This is an info.menu in rootdir2/dir4", :priority=>0, :os=>"all", :type=>"dir", :path=>"./dir4", :rootdir=>"spec/fixtures/rootdir2"}},
      {'dir5' => [], :items_for_parent => {:title=>"dir5", :type=>"dir", :path=>"./dir5", :rootdir=>"spec/fixtures/rootdir2"}}
    ], :items_for_parent => { :title=>"dir1", :type=>"dir", :path=>"./dir1", :rootdir=>"spec/fixtures/rootdir1" }},
    {'rootdir3' => [
      {'dira' => [
        {'script.rb' => [], :items_for_parent => {:title=>"script.rb", :type=>"script", :path=>"dira/script.rb", :rootdir=>"spec/fixtures/rootdir3"}},
      ], :items_for_parent => {:title=>"dira", :type=>"dir", :path=>"./dira", :rootdir=>"spec/fixtures/rootdir3"}}, 
      {'dirb' => [], :items_for_parent => {:title=>"dirb", :type=>"dir", :path=>"./dirb", :rootdir=>"spec/fixtures/rootdir3"}}, 
      {'dirc' => [], :items_for_parent => {:title=>"dirc", :type=>"dir", :path=>"./dirc", :rootdir=>"spec/fixtures/rootdir3"}}
    ], :items_for_parent => { :title=>"dir1", :type=>"dir", :path=>"./dir1", :rootdir=>"spec/fixtures/rootdir1" }},
  ]
  x = path.inject(rootdirs) do |result, path| 
    result.inject(:merge)[path]
  end
  
  if options[:single]
    x.select do |e| e.keys.first == last end.first[:items_for_parent]
  else
    x.map {|e |e[:items_for_parent]}
  end
end

def full_path(item)
  item['rootdir']+'/'+item['path']
end

fixtures_folder "rootdir2/dir1", :single => true 


