require 'rubygems'
require 'bundler/setup'

require 'rspec/mocks/standalone'
require 'polvomenu' 

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.run_all_when_everything_filtered = true
  c.filter_run :focus
  @output         = ''
  @err            = ''
  $stdout.stub!(:write) { |*args| @output.<<( *args ) }
  $stderr.stub!(:write) { |*args| @err.<<( *args )}
end


## Track original $stdout, $stderr write methods so we can restore them for
## debugging
#class << $stdout
#  alias_method :real_write, :write
#end
#class << $stderr
#  alias_method :real_write, :write
#end
#
#class Object
#  def debug
#    # For debugging, restore stubbed write
#    class << $stdout
#      alias_method :write, :real_write
#    end
#    class << $stderr
#      alias_method :write, :real_write
#    end
#
#    require 'ruby-debug'
#    debugger
#  end
#end