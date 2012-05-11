require 'spec_helper'
require 'pp'

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

  describe "#get_script_info" do

    it "should return a hash if file exists" do
      subject.get_script_info('spec/fixtures/rootdir2','dir4/info.menu').class.should == Hash
    end

    it "should return nil if file does not exist" do
      subject.get_script_info('spec/fixtures/rootdir0','dir0').should be_nil
    end

    it "should have :type == 'script' if option is script" do
      subject.get_script_info('spec/fixtures/rootdir3','dira/script.rb')[:type].should == "script"
    end
  end

  describe "#get_dir_info" do
    it "should use folder name as title if folder does not contain info.menu" do
      subject.get_dir_info('spec/fixtures/rootdir1','dir1')[:title].should == "dir1"
    end    

    it "should use info.menu to generate title if folder contains info.menu" do
      subject.get_dir_info('spec/fixtures/rootdir1','dir3')[:title].should == "This is an exec.bash inside rootdir1/dir3"
    end
    
    it "should have :path pointing to exec.bash if folder contains exec.bash" do
      subject.get_dir_info('spec/fixtures/rootdir1','dir3')[:path].should == "dir3/exec.bash"
    end

    it "should have :path pointing to folder if folder does not contain exec.bash" do
      subject.get_dir_info('spec/fixtures/rootdir1','dir1')[:path].should == "dir1"
    end

    it "should have :type == 'dir' if option is directory" do
      subject.get_dir_info('spec/fixtures/rootdir3','dirb')[:type].should == "dir"
    end

    it "should have :type == 'script' if option is folder with exec.bash" do
      subject.get_dir_info('spec/fixtures/rootdir1','dir3')[:type].should == "script"
    end

    it "should call get_script_info if folder contains exec.bash" do
      subject.should_receive(:get_script_info).with("spec/fixtures/rootdir1","dir3/exec.bash")
      subject.get_dir_info('spec/fixtures/rootdir1','dir3')
    end

    it "should call get_script_info if folder contains info.menu" do
      pending "Does not work, can't figure out why!"
      subject.should_receive(:get_script_info)#.with("rootdir2","dir4/info.menu")
      subject.get_dir_info('spec/fixtures/rootdir2','dir4')
    end

  end
    
  describe "#generate_menu_items" do
    it "should generate a menu ordered alphabetically by folders :title's" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir1"]
      ordered_titles = menu.generate_menu_items(".").collect {|i| i[:title] }
      ordered_titles.should == fixtures_folder("rootdir1").collect {|i| i[:title] }.sort
    end

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
    
    it "should ignore dotfiles and info.menu" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3/"]
      items_basenames = menu.generate_menu_items('dirb/dirb1').collect {|i| File.basename(i[:path]) }
      items_basenames.each {|n| n.should_not match /^\./ } 
      items_basenames.each {|n| n.should_not match /^info.menu$/ } 
    end

    it "should sort by priority then alphabetically" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3/"]
      priority_ordered_items = menu.generate_menu_items('dirb/dirb1')
      priority_ordered_items.collect {|i| i[:title]}.should == ['Ruby script', 'Bash script', 'Perl script']
    end

    it "should not show folder if it contains info.menu with 'hidden' setting" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3/"]
      items = menu.generate_menu_items('dira').collect {|i| i[:path] }.should_not include 'dira/dir_hidden'
    end

    it "should not show script if it contains 'hidden' setting" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3/"]
      items = menu.generate_menu_items('dira').collect {|i| i[:path] }.should_not include 'dira/script_hidden'
    end

    it "items should have multi-line description if header has multi-line description" do
      menu = Polvo::Menu.new ["spec/fixtures/rootdir3"]
      descriptions = menu.generate_menu_items('dirb/dirb1').collect {|i| i[:desc] }.each do |i|
        i.should match /\n/
      end
    end

# Next tests:

    it "should show only Ubuntu/all scripts if OS is Ubuntu" do
      pending "This is not yet implemented!"
    end
    
    it "should show only MacOS/all scripts if OS is MacOS" do
      pending "This is not yet implemented!"
    end
    
    it "should warn when directory is empty" do
      pending "This is not yet implemented!"
    end
    
    it "should bla bla bla descriptions" do
      pending "This is not yet implemented!"
    end

  end  

end

