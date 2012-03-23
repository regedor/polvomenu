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
      question = options['question'] || 'Choice: '
      self.clear                     unless options['noclear']
      self.h1(options['title'])      if options['title']
      self.p(options['description']) if options['description']
      i = 0 
      items.each do |item|
        opt = (sprintf "%5d",i+1).gsub!(/\s(\d)/,'[\1')
        puts "#{opt}] #{item}"
        i+=1
      end
      self.warn(options['warn']) if options['warn']
      return self.ask(question)
    end
    
    
    # --------------------------------------
    #  More useful methods
    # --------------------------------------
    def clear
      system('clear')
    end
    
    def debug(str)
      puts str.magenta
    end
    
  end
end
