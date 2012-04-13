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
    
   # Polvo::Menu.new ["spec/fixtures/rootdir1/"]
   # it "should generate a simple menu" do
   #   items_representation = menu.generate_menu_items("dir1") 
   #   items_representation.should == [
   #     { "title"=>"dir1", 
   #       "type"=>"dir", 
   #       "path"=>"./dir1", 
   #       "rootdir"=>"spec/fixtures/rootdir2"}, 
   #   ]      
   # end
  

  
  end  
end

