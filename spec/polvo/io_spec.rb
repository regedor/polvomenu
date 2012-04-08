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
    valid_answer            = "3"
    invalid_answer_n1       = "6"
    invalid_answer          = "6"
    items_advanced          = ["Option 1","Option 2","Option 3",{:label => "All of them", :answer => "all"},"Option 4"]
    extra_answers           = ["7","","lol","sdf"]
    extra_answer            = "7"
    valid_answer_with_args  = "3d lol"

    
    it "should not acept invalid answer" do
      $stdin.should_receive(:gets).and_return(invalid_answer,valid_answer)
      subject.menu(items).should == valid_answer
    end
    
    it "should not acept answer '0'" do
      $stdin.should_receive(:gets).and_return("0",valid_answer)
      subject.menu(items).should == valid_answer
    end
    
    it "should not acept answer 'n+1' for 'n' sized items  " do
      $stdin.should_receive(:gets).and_return(invalid_answer_n1,valid_answer)
      subject.menu(items).should == valid_answer
    end
    
    it "should acept answer with args if extended_option is true" do
      $stdin.should_receive(:gets).and_return(valid_answer_with_args)
      subject.menu(items, :extended_options => true).should == valid_answer_with_args
    end
 
    it "should not acept invalid answer if extended_option is true" do
      $stdin.should_receive(:gets).and_return(invalid_answer, valid_answer)
      subject.menu(items, :extended_options => true).should == valid_answer
    end
    
    it "should accept '7' if receives extra_answers with it" do
      $stdin.should_receive(:gets).and_return(extra_answer)
      subject.menu(items_advanced,:extra_answers => extra_answers).should == extra_answer
    end
    
    it "should accept all if receives extra_answers with it" do
      $stdin.should_receive(:gets).and_return("all")
      subject.menu(items_advanced).should == "all"
    end
    
    it "should not accept extended options if not specified" do
      $stdin.should_receive(:gets).and_return("all kaka", "all")
      subject.menu(items_advanced).should == "all"
    end
    
    it "should accept extended options if specified" do
      $stdin.should_receive(:gets).and_return("all kaka")
      subject.menu(items_advanced,:extended_options => true).should == "all kaka"
    end
    
    it "should not accept invalid answer even with extra answers" do
      $stdin.should_receive(:gets).and_return(invalid_answer,extra_answer)
      subject.menu(items, :extended_option => false, :extra_answers => extra_answers).should == extra_answer
    end
    
    it "should not accept 5 when number of normal items in the items array is < 5" do
      $stdin.should_receive(:gets).and_return("5",valid_answer)
      subject.menu(items_advanced).should == valid_answer
    end
    
    it "should accept option n where n is the number of normal items in the items array" do
      $stdin.should_receive(:gets).and_return("5",valid_answer)
      subject.menu(items_advanced).should == valid_answer
    end
    
  end
  
  it ".clear should have tests" do
    pending "write tests or I will kneecap you"
  end

end

