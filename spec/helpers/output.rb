
  
  # Track original $stdout, $stderr write methods 
  # so we can restore them for debugging
  class << $stdout
    alias_method :real_write, :write
  end
  class << $stderr
    alias_method :real_write, :write
  end

  class Object
    def debug
      # For debugging, restore stubbed write
      class << $stdout
        alias_method :write, :real_write
      end
      class << $stderr
        alias_method :write, :real_write
      end
      require 'ruby-debug'
      debugger
    end
  end

  @output = ''
  @err    = ''
  $stdout.stub!(:write) { |*args| @output.<<( *args ) }
  $stderr.stub!(:write) { |*args| @err.<<( *args )    }
