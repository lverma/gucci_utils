# Re-open the String class to add some formatting ANSI-friendly methods (chainable)
class String
  
  @@color_codes = {
    :red => 31,
    :green => 32,
    :yellow => 33,
    :blue => 34,
    :magenta => 35,
    :cyan => 36,
    :grey => 37
  }

  # Return string with bold characters
  def bold
    "\e[1m#{self}"
  end
  
  # Reset bold style
  def normal
    "\e[0m#{self}"
  end
  
  def method_missing(id, *args, &block)
    if @@color_codes.keys.include?(id)
      "\e[#{@@color_codes[id]}m#{self}\e[0m"
    else
      super
    end
  end
end

module Utils
  
  ASTERISKS_LEN = 90
  
  # Dsiplay a spacer between a block of info by:
  # 1. printing a new line
  # 2. printing a specified (by utility constant) number of asterisks
  # 3. printing the passed string
  def print_spacer(s)
    puts
    puts ('*' * ASTERISKS_LEN).grey.bold
    puts s.green
  end
  
  # Display an error by:
  # 1. extracting its message 
  # 2. executing the passed (if any) to invoke callbacks before re-raising the error
  # 3. raising the error again
  def print_e(e, &b)
    puts "*** ERROR: #{e.message}".red.bold
    b.call if block_given?
    raise e
  end
  
  # Read user input by asking a question.
  def ask message
    print message
    STDIN.gets.chomp
  end
  
  # Ask for confirmation Y/N to user by:
  # 1. accepting a message and a block to be executed
  # 2. waiting for user input
  # 3. if the response is Y, call the passed block
  # 4. if the response is N, abort task
  def confirm(msg, &b)
    begin
      res = ask "#{msg} (Y/N)?"
    end until %w(Y N y n).include?(res)
    if res =~ /y/i
      b.call
    elsif res =~ /n/i
      puts 'Aborting...'.red.bold
    end
  end
  
  # Ask to enter one of the available choice by:
  # 1. accepting a message, an array of valid choices and a block to be executed
  # 2. waiting for user input
  # 3. if the response is a valid choice, call the passed block by passing it
  # 4. if the response is not, ask again
  def choose(msg, choices, multiple = true, &b)
    options = choices.is_a?(Hash) ? choices.keys.map(&:to_s) : choices
    labels = choices.is_a?(Hash) ? choices.map { |k,v| "#{v} [" + "#{k}".yellow.bold + "]".normal } : choices.map { |choice| choice.to_s.yellow.bold }
    begin
      multiple_selection = multiple ? ' - use '.magenta + '+'.bold + ' to separate choices, '.magenta + '*'.bold + ' for all - '.magenta : ' '
      res = ask "#{msg}".bold + multiple_selection + "(#{labels.join(' - ')})?".normal
      responses = multiple ? (res == '*' ? options : res.split('+').map(&:strip)) : res
    end until responses.all? { |r| options.include?(r) }
    responses.each do |r|
      b.call(r)
    end
  end
end