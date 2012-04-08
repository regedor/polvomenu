require 'rubygems'
require 'pp'
require 'colorize'

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

class Array
  def to_menu
    Polvo::IO.menu(self).to_i - 1 
  end
end

require_relative 'polvo'
require_relative 'polvo/menu/version'
require_relative 'polvo/io'
require_relative 'polvo/menu'

OUT = Polvo::IO
