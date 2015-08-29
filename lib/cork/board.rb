module Cork
  #Provides support for UI output. Cork provides support for nested
  #sections of information and for a verbose mode.
  # thinking we might want to move lines 50-62 from user_interface.rb to board.rb
  # if not why were these lines important to u_i.rb ?
  class Board
    attr_reader :input
    attr_reader :out
    attr_reader :err
    attr_reader :warnings

   #including those two related accessor related attr's becaues they relate to
   #indentation
   #attr_accessor :disable_wrap
   #alias_method :disable_wrap?, :disable_wrap
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

    def section(title, verbose_prefix = '', relative_indentation = 0)
      if config.verbose?
        title(title, verbose_prefix, relative_indentation)
      elsif title_level < 1
        puts title
      end

      self.indentation_level += relative_indentation
      self.title_level += 1
      yield if block_given?
      self.indentation_level -= relative_indentation
      self.title_level -= 1
    end

    # In verbose mode it shows the sections and the contents.
    # In normal mode it just prints the title.
    #
    # @return [void]
    #
    def titled_section(title, options = {})
      relative_indentation = options[:relative] || 0
      verbose_prefix = options [:verbose_prefix] || ''
      if config.verbose?
        title(title, verbose_prefix, relative_indentation)
      else
        puts title
      end

      self.indentation_level += relative_indentation
      self.title_level += 1
      yield if block_given?
      self.indentation_level -= relative_indentation
      self.title_level -= 1
    end

      # A title opposed to a section is always visible
      #
      # @param [String] title
      #         The title to print
      #
      # @param [String] verbose_prefix
      #         See #message
      #
      # @param [FixNum] relative_indentation
      #         The indentation level relative to the current,
      #         when the message is printed.
      #
      def title (title, verbose_prefix = '', relative_indentation = 2)
        if @treat_titles_as_messages
          message(title, verbose_prefix)
        else
          title = verbose_prefix + title if config.verbose?
          title = "\n#{title}" if @title_level < 2
          if (color = @title_colors[title_level])
            title = title.send(color)
          end
          puts "#{title}"
        end

        self.indentation_level += relative_indentation
        self.title_level += 1
        yield if block_given?
        self.indentation_level -= relative_indenation
        self.title_level -= 1
      end

      # def title(title, verbose_prefix = '', relative_indentation = 2)
      # end

      # Prints a verbose message taking an optional verbose prefix and
      # a relatvie indentation valid for the UI action in the passed block.
      #
      # @todo Clean interface.
      #
      #@param [String] message
      #       The message to print.
      #
      #@param [String] verbose_prefix
      #        See #message
      #
      # @param [FixNum] relative_indentation
      #         The indentation level relative to the current,
      #         when the message is printed.
      #

      private

      # @!group Helpers
      #----------------------------------------------------------------------#

      # @return [String] Wraps a string taking into account the width of the
      # terminal and an option indent. Adapted from
      # http://blog.macromates.com/2006/Wrapping-text wrapping-text-with-regular-expressions/
      #
      # @param [String] txt    The string to wrap
      #
      # @param [String] indent The string to use to indent the result.
      #
      # @return [String]       The formatted string.
      #

    attr_accessor :indentation_level
    attr_accessor :title_level

    # Prints a title taking an optional verbose prefix and
         # a relative indentation valid for the UI action in the passed
         # block.
         #
         # In verbose mode titles are printed with a color according
         # to their level. In normal mode titles are printed only if
         # they have nesting level smaller than 2.
         #
         # @todo Refactor to title (for always visible titles like search)
         #       and sections (titles that represent collapsible sections).
         #
         # @param [String] title
         #        The title to print
         #
         # @param [String] verbose_prefix
         #        See #message
         #
         # @param [FixNum] relative_indentation
         #        The indentation level relative to the current,
         #        when the message is printed.
         #

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
      first_space = ' ' * indent
      if disable_wrap
        first_space << string
      else
        indented = TextWrapper.wrap_with_indent(string, indent, 9999)
        first_space << indented
      end
    end
  end
end


#--- bring in def notice, def wrap_string and and also the wrap string in UI
# and several other things
#--puts warning, def info, def label, def puts indented---#
