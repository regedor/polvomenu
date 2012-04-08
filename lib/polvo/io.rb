module Polvo::IO
  class << self
    
    # --------------------------------------------
    #  Simple methods for outputing semantic text
    # --------------------------------------------
    def h1(str)
      printf "\n === #{str.upcase} ===\n\n"
    end
    
    def h2(str)
      self.h1(str)
    end
    
    def h3(str)
      self.h1(str)
    end
    
    def h4(str)
      self.h1(str)
    end
    
    def h5(str)
      self.h1(str)
    end
    
    def p(str)
      print str,"\n\n"
    end
    
    def notice(str)
      puts "*** #{str}".green
    end
    
    def warning(str)
      puts "*** #{str}".yellow
    end

    def error(str)
      puts "*** #{str}".red
    end
    
    
    # ---------------------------------------------
    #  Simple methods that expect user interaction
    # ---------------------------------------------
    def wait(str='Press ENTER to continue.')
      puts
      self.warning(str)
      STDIN.gets
    end
    
    def confirm(str="Continue")
      printf "\n#{str} [y/n] ".yellow
      input = STDIN.gets.chomp
      return( %w{y Y yes YES}.any? {|v| v == input} )
    end
    
    def ask(str)
      printf "\n#{str}"
      return STDIN.gets.chomp
    end
   
   
    # items can be hashes or string. 
    #   Sample: 
    #      [{:answer => "gt", :label => "option 1"}, {:answer => "0", :label => "option 2"}] 
    #      ["option 1", "option 2"] 
    #        
    #      Always returns the array index position
    def menu(items,options = {})
      question = options['question'] || 'Choice: '
      
      #Print Menu header
      self.clear                     unless options['noclear']
      self.h1(options['title'])      if options['title']
      self.p(options['description']) if options['description']

      # Print menu options
      normal_items_counter = 0 
      items.each do |item|
        if item.is_a? Hash
          opt = sprintf("%5s",item[:answer]).gsub!(/\s(\w)/,'[\1')
          puts "#{opt}] #{item[:label]}"
        else
          normal_items_counter+=1
          opt = (sprintf "%5d",normal_items_counter).gsub!(/\s(\d)/,'[\1')
          puts "#{opt}] #{item}"
        end
      end

      # Show warn (if any) and read user choice
      self.warning(options['warn']) if options['warn']
      options.delete 'warn'
      choice = self.ask(question)
      
      # Parse user choice
      more_acceptable_answers = options[:extra_answers] || [] 
      items.each { |i| more_acceptable_answers << i[:answer] if i.is_a?(Hash) }
      if option = parse_choice(choice, normal_items_counter, options[:extended_options], more_acceptable_answers)
        return option
      else
        options['warn'] = "'#{choice}' is not a valid option!" 
        return self.menu(items,options)
      end
    end
    
    
    
    # --------------------------------------
    #  More useful methods
    # --------------------------------------
    def clear
      if ENV['POLVO_DEBUG']
        puts "\n\n\n\n"
      else
        system('clear')
      end
    end
    
    def debug(str)
      puts str.magenta
    end
    
  private
  
    # Extended mode (accepts integers followed by anything, ex: '3e file')
    # Extra answers (ex: '', '0', 'weird option')
    def parse_choice(choice, max, extended_options, more_acceptable_answers=[])
      # Normal mode (accepts only integers > 0 and <= max, ex: '3')
      if choice =~ /^\d+$/ && int_choice = choice.to_i 
        return choice if int_choice > 0 && int_choice < max
      end
      return choice if more_acceptable_answers.include?(choice)
      if extended_options
        if choice =~ /^(\d+)/ 
          int_choice = $1.to_i 
          return choice if int_choice > 0 && int_choice <= max
        end
        return choice if more_acceptable_answers.map { |a| /^#{Regexp.escape(a)}/ }.any? {|regexp| choice =~ regexp }
      end
      return false
    end
    
  end
end
