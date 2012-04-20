require 'spec_helper'

describe Polvo::Menu do
  subject { Polvo::Menu.new ["spec/fixtures/rootdir1/", "spec/fixtures/rootdir2"] }
  
  describe "#render" do
    it "should generate menu items and call show_menu" do
      subject.should_receive(:generate_menu_items).with(".").and_return(:the_items_representation)
      subject.should_receive(:show_menu).with(:the_items_representation,{})
      subject.render
    end 
    
    it "should pass to show_menu fake options given" do
      subject.should_receive(:generate_menu_items).with("dir1").and_return(:the_items_representation)
      subject.should_receive(:show_menu).with(:the_items_representation,{:fake_option_key => 'fake_option_value'})
      subject.render 'dir1', :fake_option_key => 'fake_option_value'
    end
    
    it "should return exit value from show_menu" do
      subject.should_receive(:generate_menu_items).with(".").and_return(:the_items_representation)
      subject.should_receive(:show_menu).with(:the_items_representation,{}).and_return(:return_value)
      return_value = subject.render 
      return_value.should == :return_value
    end
    
  end
  
  describe "#generate_menu_items" do
# ordered alphabetically
    it "should generate a menu with local path == '.'" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3/"]
      items_representation = menu.generate_menu_items(".")
      items_representation.should == fixtures_folder("rootdir3").sort {|a,b| [(a[:priority] || 0), a[:title] ] <=> [(b[:priority] || 0), b[:title]] }

    end
    
    it "should generate a simple menu with local path != '.'" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir1/"]
      items_representation = menu.generate_menu_items("dir1") 
      items_representation.should == fixtures_folder("rootdir1/dir1")       
    end
    
    it "should merge with priority to last folder" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir1/","spec/fixtures/rootdir2"]
      items_representation = menu.generate_menu_items(".") 
      items_representation.should == [
        (fixtures_folder "rootdir2/dir1", :single => true) ,
        (fixtures_folder "rootdir2/dir2", :single => true) ,
        (fixtures_folder "rootdir1/dir3", :single => true) ,
        (fixtures_folder "rootdir2/dir4", :single => true) ,
        (fixtures_folder "rootdir2/dir5", :single => true) ,    
      ].sort {|a,b| [(a[:priority] || 0), a[:title] ] <=> [(b[:priority] || 0), b[:title]] }
    end
    
    it "should merge with priority to last folder" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir2/","spec/fixtures/rootdir1"]
      items_representation = menu.generate_menu_items(".") 
      items_representation.should == [
        (fixtures_folder "rootdir1/dir1", :single => true) ,
        (fixtures_folder "rootdir1/dir2", :single => true) ,
        (fixtures_folder "rootdir1/dir3", :single => true) ,
        (fixtures_folder "rootdir2/dir4", :single => true) ,
        (fixtures_folder "rootdir2/dir5", :single => true) ,    
      ].sort {|a,b| [(a[:priority] || 0), a[:title] ] <=> [(b[:priority] || 0), b[:title]] }
    end
    
# Next tests:
#
# it "should use folder name as title if folder does not contain info.menu"
# it "should use info.menu to generate title if folder contains info.menu"
# it "should show only Ubuntu/all scripts if OS is Ubuntu"
# it "should show only MacOS/all scripts if OS is MacOS"
# it "should sort by priority then alphabetically"
#
# it "should have :path pointing to exec.bash if folder contains exec.bash"
# it "should not show folder if folder contains info.menu with 'hidden' setting"
# it "should have :type == 'dir' if option is directory"
# it "should have :type == 'script' if option is script"
# it "should have :type == 'script' if option is folder with exec.bash"
# it "should ignore dotfiles and info.menu"
# it "should warn when directory is empty"

  end  
end

