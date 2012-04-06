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
      puts
    end
    
    def ask(str)
      printf "\n#{str}"
      return STDIN.gets.chomp
      puts
    end
   
    def menu(items,options = {})
      # Clear screen, show title and drescription
      question = options['question'] || 'Choice: '
      self.clear                     unless options['noclear']
      self.h1(options['title'])      if options['title']
      self.p(options['description']) if options['description']

      # Print menu options
      i = 0 
      items.each do |item|
        if item.class == 'Hash'
          opt = sprintf("%5s",item[:answer]).gsub!(/\s(\w)/,'[\1')
          puts "#{opt}] #{item[:label]}"
        else
          opt = (sprintf "%5d",i+1).gsub!(/\s(\d)/,'[\1')
          puts "#{opt}] #{item}"
          i+=1
        end
      end

      # Show warn (if any) and read user choice
      self.warning(options['warn']) if options['warn']
      options.delete 'warn'
      choice = self.ask(question)
      
      # Parse user choice
      if option = parse_choice(choice,items.count+1,options)
        return option
      else
        options['warn'] = "'#{choice}' is not a valid option!" 
        return self.menu(items,options)
      end
    end
    
    def parse_choice(choice, max, options = {})
      # Normal mode (accepts only integers > 0 and <= max, ex: '3')
      if choice =~ /^\d+$/
        int_choice = Integer(choice)
        return int_choice if int_choice > 0 and int_choice <= max
      end

      # Extended mode (accepts integers followed by anything, ex: '3e file')
      if options[:extended_options]
        if choice =~ /^(\d+)(.*?)$/
          int_choice = '\1'
          args = '\2'
          return { :option => '\1', :args => '\2' } if int_choice > 0 and int_choice <= max
        end
      end
      
      # Extra answers (ex: '', '0', 'weird option')
      if options[:extra_answers]
        return choice if options[:extra_answers].include?(choice)
      end

      return false
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
    
  end
end
