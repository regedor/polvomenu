module Polvo::Printer
  def self.h1(str)
    printf "\n === "
    printf str.upcase  
    printf " ===\n\n"
  end

  def self.h2(str)
    self.h1(str)
  end

  def self.h3(str)
    self.h1(str)
  end


  def self.h4(str)
    self.h1(str)
  end

  def self.h5(str)
    self.h1(str)
  end
  
  def self.p(str)
    print "\n",str,"\n\n"
  end

  def self.error(str)
    str = '*** '+str
    puts str.red
  end

  def self.warn(str)
    str = '*** '+str
    puts str.yellow
  end

  def self.ok(str)
    str = '*** '+str
    puts str.green
  end

  def self.wait(str='Press ENTER to continue.')
    puts
    self.warn(str)
    STDIN.gets
  end
  
  def self.debug(str)
    puts str.magenta
  end

  def self.ask(str)
    printf "\n#{str}"
    return STDIN.gets.chomp
    puts
  end

  def self.clear
    puts
    #system('clear')
  end

  def self.menu(items,options = {})
    question = options['question'] || 'Choice: '
    self.clear unless options['noclear']
    Printer.h1(options['title']) if options['title']
    i = 0 
    items.each do |item|
      opt = (sprintf "%5d",i+1).gsub!(/\s(\d)/,'[\1')
      puts  "#{opt}] #{item}"
      i+=1
    end
    Printer.warn(options['warn']) if options['warn']
    return self.ask(question)
  end
end
