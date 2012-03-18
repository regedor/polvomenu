require 'spec_helper'

describe Polvo::Printer do
  before(:each) do
    @output = ''
    @err    = ''
    $stdout.stub!(:write) { |*args| @output.<<( *args ) }
    $stderr.stub!(:write) { |*args| @err.<<( *args )    }
  end

  # should respond_to .method with 1 argument
  %w{h1 h2 h3 h4 h5 p notice warning error}.each do |method|
    it { should respond_to(method).with(1).argument } 
  end
  
  # .h1*(str) should output
  %w{h1 h2 h3 h4 h5 p notice warning error}.each do |method|
    ["text", "coisas loucas", "pumba\npumba"].each do |text|
      it ".#{method}('#{text}') should output (write on stdout, case insensitive): #{text}" do
        Polvo::Printer.send method, text
        @output.should =~ /#{text}/i
      end
    end
  end
  
  # .h1*(str) should capitalize
  %w{h1 h2 h3 h4 h5}.each do |method|
    {"mouse" => "MOUSE"}.each do |input, output|
      it ".#{method} when called with '#{input}', should output: #{output}" do
        Polvo::Printer.send method, input
        @output.should =~ /#{output}/
      end
    end
  end
   
  # .wait(text) show text and do a gets" do
  it ".wait(text) show text and do a gets" do
    text = "warning message"
    $stdin.should_receive(:gets).once
    subject.wait(text)
    @output.should =~ /#{text}/
  end
  
  # .confirm(question) should return true/false when user answers yes/no " do
  {"yes"=> true, "y" => true, "YES" => true, "Y" => true,
   "no" => false,"n" => false,"NO" => false, "N" => false}.each do |answer, value|
    it ".confirm should return #{value} when user answers '#{answer}' " do
      question = "Queres bananas?"
      $stdin.should_receive(:gets).and_return(answer)
      subject.confirm(question).should == value
    end
  end
  
    
  it "should have the method ask that returns the user input" do
    question, answer = "Queres bananas?", "Sim"
    $stdin.should_receive(:gets).and_return(answer)
    $stdout.should_receive(:write).with("\n#{question}")
    subject.ask(question).should == answer  
  end
  
  
  


# # 

end

