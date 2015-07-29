module Cork
 class Board
  attr_reader :input
  attr_reader :out
  attr_reader :err

    def initialize(verbose: false, silent: false, ansi: true,
                   input: $stdin, out: $stdout, err: $stderr)
      @input = input
      @out = out
      @err = err
      @verbose = verbose
      @silent = silent
      @ansi = ansi
    end

    def verbose?
      @verbose
    end

    def silent?
      @silent
    end

    def ansi?
      @ansi
    end
    # prints a message followed by a new line unless config is silent. This is where we moved line 241  to 255 kind of over from user_interface.rb in CP to Cork  board.rb

    #
    def puts(message = '')
      out.puts(message) unless silent?
    end

    # prints a message followed by a new line unless config is silent.
    #
    def print(message)
      out.print(message) unless silent?
    end

    # gets input from $stdin
    #
    def gets
      input.gets
    end

    # Stores important warming to the user optionally followed by actions that the user should take. To print them use {#print_warnings}.
    #
    # @param [String] message The message to print.
      @param [Array]  actions The actions that the user should take.
    #
    # return [void]
    #
    def warn(message, actions =[],verbose_only = false)
      warnings << { :message =>, :actions  => actions, :verbose_only => }
    end

    private
end
