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
  end
end
