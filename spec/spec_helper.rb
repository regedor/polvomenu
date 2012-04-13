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

def fixtures_folder(string_path)
  rootdirs = [ 
    {'rootdir1' => [
      {'dir1' => [], :items_for_parent => { "title"=>"dir1", "type"=>"dir", "path"=>"./dir1", "rootdir"=>"spec/fixtures/rootdir1" }}, 
      {'dir2' => [], :items_for_parent => { "title"=>"dir2", "type"=>"dir", "path"=>"./dir2", "rootdir"=>"spec/fixtures/rootdir1" }}, 
      {'dir3' => [], :items_for_parent => { "title"=>"This is an exec.bash inside rootdir1/dir3", "os"=>"ubuntu", "type"=>"script", "path"=>"./dir3/exec.bash", "rootdir"=>"spec/fixtures/rootdir1" }}
    ], :items_for_parent => { "title"=>"dir1", "type"=>"dir", "path"=>"./dir1", "rootdir"=>"spec/fixtures/rootdir1" }},
    {'rootdir3' => [
      {'dira' => [], :items_for_parent => {"title"=>"dira", "type"=>"dir", "path"=>"./dira", "rootdir"=>"spec/fixtures/rootdir3"}}, 
      {'dirb' => [], :items_for_parent => {"title"=>"dirb", "type"=>"dir", "path"=>"./dirb", "rootdir"=>"spec/fixtures/rootdir3"}}, 
      {'dirc' => [], :items_for_parent => {"title"=>"dirc", "type"=>"dir", "path"=>"./dirc", "rootdir"=>"spec/fixtures/rootdir3"}}
    ], :items_for_parent => { "title"=>"dir1", "type"=>"dir", "path"=>"./dir1", "rootdir"=>"spec/fixtures/rootdir1" }},
  ]
  string_path.split("/").inject(rootdirs) do |result, path| 
    result.inject(:merge)[path]
  end.map {|e |e[:items_for_parent]}
end


