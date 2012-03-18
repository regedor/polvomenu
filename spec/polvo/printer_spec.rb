require 'spec_helper'

describe Polvo::Printer do
  p = Polvo::Printer
  
#  it { 
#    text = "lola"
#    Polvo::Printer.p(text)
#    puts "pi"
#    puts @output
#    puts "pi"
#    (@output =~ /#{text}/).should_not be_nil
#    }
#  #  
  #it { should respond_to :h2(   str)
  #it { should respond_to :h3(   str)
  #it { should respond_to :h4(   str)
  #it { should respond_to :h5(   str)
  #it { should respond_to :p(    str)
  #it { should respond_to :error(str)
  #it { should respond_to :warn( str)
  #it { should respond_to :ok(   str)
  #it { should respond_to :debug(str)
  
  it "should have the method ask that returns the user input" do
    question, answer = "Queres bananas?", "Sim"
    $stdin.should_receive(:gets).and_return(answer)
    $stdout.should_receive(:write).with("\n#{question}")
    p.ask(question).should == answer  
  end
  
# # 
#
# #
# #
# #
# # def self.wait(str='Press ENTER to continue.')
# #   puts
# #   self.warn(str)
# #   STDIN.gets
# # end
# # 
#  it "should have h1" do
#    
#    #Polvo::Printer.should_receive(:printf).with("ASD")
#    #STDOUT.should_receive(:print)
#    #Polvo::Printer.h1("asd")
#    
#    STDIN.should_receive(:gets).and_return("lol")
#    Polvo::Printer.ask("asd").should == "lolg"
#    
#  end
end

