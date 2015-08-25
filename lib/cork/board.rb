module Cork
  class Board
    attr_reader :input

    attr_reader :out
    attr_reader :err

    attr_reader :warnings

    def initialize(verbose: false, silent: false, ansi: true,
                   input: $stdin, out: $stdout, err: $stderr)
      @input = input
      @out = out
      @err = err
      @verbose = verbose
      @silent = silent
      @ansi = ansi
      @warnings = []
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

    # prints a message followed by a new line unless config is silent.
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

    # Stores important warning to the user optionally followed by actions that
    # the user should take. To print them use {#print_warnings}.
    #
    #  @param [String] message The message to print.
    #  @param [Array]  actions The actions that the user should take.
    #
    # return [void]
    #
    def warn(message, actions = [], verbose_only = false)
      warnings << {
        :message      => message,
        :actions      => actions,
        :verbose_only => verbose_only,
      }
    end

    def path(pathname, relative_to = Pathname.pwd)
      if pathname
        path = Pathname(pathname).relative_path_from(relative_to)
        "`#{path}`"
      else
        ''
      end
    end

    def labeled(label, value, justification = 12)
      if value
        title = "- #{label}:"
        if value.is_a?(Enumerable)
          lines = [wrap_string(title, indentation_level)]
          value.each do |v|
            lines << wrap_string("- #{v}", indentation_level + 2)
          end
          puts lines.join("\n")
        else
          string = title.ljust(justification) + "#{value}"
          puts wrap_string(string, indentation_level)
        end
      end
    end

    private

    # @!group Helpers
    #-------------------------------------------------------------------#

    # @return [String] Wraps a string taking into account the width of the
    # terminal and an option indent. Adapted from http://blog.macromates.com/2006/wrapping-text-with-regular-expressions/
    #
    # @param [String] txt The string to wrap=
    #
    # @param [String] indent The string to use to indent the result.
    #
    # @return [String]    The formatted string.
    #
    # @note If Cork is not being run in a terminal or the width of the
    # terminal is too small a width of 80 is assumed.
    #
    def wrap_string(string, indent = 0)
      if disable_wrap
        (' ' * indent) + string
      else
        first_space = ' ' * indent
        indented = TextWrapper.wrap_with_indent(string, indent, 9999)
        first_space + indented
      end
    end
  end
end

#--- bring in def notice, def wrap_string and and also the wrap string in UI
# and several other things
#--puts warning, def info, def label, def puts indented---#
