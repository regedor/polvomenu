require 'spec_helper'

describe Polvo::Menu do
  subject { Polvo::Menu.new ["spec/fixtures/rootdir1/", "spec/fixtures/rootdir2"] }
  
  describe "#render" do
    it "should calculate menu items and have default values" do
      subject.should_receive(:generate_menu_items).with(".").and_return(:the_items_representation)
      subject.should_receive(:show_menu).with(:the_items_representation,{})
      subject.render
    end 
    
    it "should calculate menu items and use the given options" do
      subject.should_receive(:generate_menu_items).with("dir1").and_return(:the_items_representation)
      subject.should_receive(:show_menu).with(:the_items_representation,{:fake_option_key => 'fake_option_value'})
      subject.render 'dir1', :fake_option_key => 'fake_option_value'
    end
    
    it "should calculate menu items and use the given options" do
      subject.should_receive(:generate_menu_items).with(".").and_return(:the_items_representation)
      subject.should_receive(:show_menu).with(:the_items_representation,{}).and_return(:return_value)
      return_value = subject.render 
      return_value.should == :return_value
    end
    
  end
  
  describe "#generate_menu_items" do

    it "should generate a simple menu" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3/"]
      items_representation = menu.generate_menu_items(".") 
      items_representation.should == fixtures_folder("rootdir3")  

    end
    
    it "should generate a simple menu" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir1/"]
      items_representation = menu.generate_menu_items("dir1") 
      items_representation.should == fixtures_folder("rootdir1/dir1")       
    end
    
    it "should merge with priority to second folder" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir1/","spec/fixtures/rootdir2"]
      items_representation = menu.generate_menu_items(".") 
      items_representation.sort {|a,b| full_path(a) <=> full_path(b) }.should == [
        (fixtures_folder "rootdir2/dir1", :single => true) ,
        (fixtures_folder "rootdir2/dir2", :single => true) ,
        (fixtures_folder "rootdir1/dir3", :single => true) ,
        (fixtures_folder "rootdir2/dir4", :single => true) ,
        (fixtures_folder "rootdir2/dir5", :single => true) ,    
      ].sort {|a,b| full_path(a) <=> full_path(b) }
    end
    
    it "should merge with priority to second folder" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir2/","spec/fixtures/rootdir1"]
      items_representation = menu.generate_menu_items(".") 
      items_representation.sort {|a,b| full_path(a) <=> full_path(b) }.should == [
        (fixtures_folder "rootdir1/dir1", :single => true) ,
        (fixtures_folder "rootdir1/dir2", :single => true) ,
        (fixtures_folder "rootdir1/dir3", :single => true) ,
        (fixtures_folder "rootdir2/dir4", :single => true) ,
        (fixtures_folder "rootdir2/dir5", :single => true) ,    
      ].sort {|a,b| full_path(a) <=> full_path(b) }
    end
  
  end  
end

