require 'spec_helper'

describe Polvo::IO do
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
  %w{h1 h2 h3 h4 h5 p notice warning error debug}.each do |method|
    ["text", "coisas loucas", "pumba\npumba"].each do |text|
      it ".#{method}(#{text.inspect}) should output #{text.inspect} (case insensitive)" do
        Polvo::IO.send method, text
        @output.should =~ /#{text}/i
      end
    end
  end
  
  # .h1*(str) should capitalize
  %w{h1 h2 h3 h4 h5}.each do |method|
    {"mouse" => "MOUSE"}.each do |input, output|
      it ".#{method}(#{input.inspect}) should output #{output.inspect}" do
        Polvo::IO.send method, input
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
  
  describe ".menu" do
    subject {Polvo::IO}
    items                   = ["Option 1","Option 2","Option 3","Option 4"]
    items_advanced          = ["Option 1","Option 2","Option 3","Option 4",{:label => "All of them", :answer => "all"}]
    valid_answer            = "3"
    invalid_answer          = "7"
    valid_answer_with_args = "3d lol"
    extra_answers           = ["7","","lol","sdf"]
    
    it "should not acept invalid answer" do
      $stdin.should_receive(:gets).and_return(invalid_answer,valid_answer)
      subject.menu(items).should == valid_answer
    end
    
    it "should acept answer with args if extended_option is true" do
      $stdin.should_receive(:gets).and_retur(valid_answer_with_args)
      subject.menu(items, :extended_option => true).should == valid_answer_with_args
    end
 
    it "should not acept invalid answer if extended_option is true" do
      $stdin.should_receive(:gets).and_return(invalid_answer, valid_answer)
      subject.menu(items, :extended_option => true).should == valid_answer
    end
    
    it "should have more tests" do
      pending "write tests or I will kneecap you"
    end
    
  end
  
  it ".clear should have tests" do
    pending "write tests or I will kneecap you"
  end

end

