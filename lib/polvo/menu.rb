require 'pp'

class Polvo::Menu
  attr_accessor :editor
  def initialize(rootdirs, options={})
    self.editor = options[:editor] || ENV['EDITOR'] || 'vim'
    @rootdirs = rootdirs.collect! { |d| d.sub(/\/*$/,'') }
  end

  def render(cur_dir = '.', options={})
    items_info = self.generate_menu_items cur_dir
    return show_menu items_info, options
  end

  #private
  
  def is_mac?
    `uname`.chomp == "Darwin"
  end
  
  def generate_menu_items(cur_dir, options={})
    items_info = Hash.new
    previous_type = 'dir'
    @rootdirs.each do |rootdir|
      next unless File.exists? "#{rootdir}/#{cur_dir}"
      
      Dir.foreach("#{rootdir}/#{cur_dir}") do |item|
        next if item == 'info.menu' or item =~ /^\./
        path = "#{cur_dir}/#{item}"
        items_info[path] = if File.directory? "#{rootdir}/#{path}"
          get_dir_info(rootdir,path)
        else
          get_script_info(rootdir,path)
        end
      end
    end
    return items_info.values.sort {|a,b| [(a[:priority] || 0), a[:title] ] <=> [(b[:priority] || 0), b[:title]] }
  end
  
  def show_menu(items_info,options={})
    menu_opts = Array.new
    a = items_info.keys.sort
    a.each do |item|
      title   = items_info[item][:title]
      path    = items_info[item][:path]
      rootdir = items_info[item][:rootdir]
      menu_opts.push("#{title}\t"+"#{rootdir}/#{path}".magenta)
    end
    
    choice = Polvo::IO.menu(menu_opts,options)
    options.delete 'warn'
    Polvo::IO.clear
    
    return true  if choice == ''
    return false if choice == '0'

    if choice_valid?(choice,items_info.length+1)
      int_choice = Integer(choice)
      warn = exec_item(items_info[a[int_choice-1]],options)
      options['warn'] = warn unless warn.nil?
    else
      options['warn'] = "'#{choice}' is not a valid option!" 
    end
    res = show_menu items_info, options
    options.delete 'warn'
    return res
  end

  def exec_item(item, options={})
    Polvo::IO.clear
    path = "#{item[:rootdir]}/#{item[:path]}"
    if File.directory?(path)
      return "Empty directory!" if Dir.entries(path).sort == ['.','..','info.menu']
      return "Empty directory!" if Dir.entries(path).sort == ['.','..']
      options[:title] = item[:title]
      exit unless self.render item[:path], options 
    else
      system(path)
      Polvo::IO.wait
    end
    return nil
  end

  
  
  def choice_valid?(choice,max)
    int_choice = Integer(choice) rescue
      if choice == ''
        return true
      else
        #Polvo::IO.warn("'#{choice}' is not a valid option!")
        return false
      end
    unless int_choice < max and int_choice >= 0
      #Polvo::IO.warn("'#{choice}' is not a valid option!")
      return false
    end
    return true
  end
  
  

  def get_dir_info(rootdir,dir)
    if File.exist? "#{rootdir}/#{dir}/exec.bash"
      return get_script_info rootdir,"#{dir}/exec.bash"
    elsif File.exist? "#{rootdir}/#{dir}/info.menu"
      info = get_script_info rootdir,"#{dir}/info.menu"
      pp info
      info[:path] = dir
      info[:type] = 'dir'
      return info
    else
      return {
        :title    => File.basename(dir),
        :type     => 'dir',
        :path     => dir,
        :rootdir  => rootdir
      }
    end
  end
    
  def get_script_info(rootdir,file)
    full_path = "#{rootdir}/#{file}"
    return nil unless File.exist?(full_path)
    return nil if File.directory?(full_path)
    filestr = IO.read("#{rootdir}/#{file}")
    if filestr =~ /^#\stitle:\s*([^\n]*)\s*$/
      title = $1 || ''
    end
    if filestr =~ /^#\sos:\s*([^\n]*)\s*$/
      os = $1 || 'all'
    end
    # priority
    # hidden
    # description
    return {
      :title => title,
      :os => os,
      :type => 'script',
      :path => file, 
      :rootdir => rootdir
    }
  end

end
