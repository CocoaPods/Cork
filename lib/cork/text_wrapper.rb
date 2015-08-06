# encoding: utf-8

module Cork
  module TextWrapper
    # @return [String] Wraps a formatted string (e.g. markdown) by stripping
    #          heredoc indentation and wrapping by word to the terminal width
    #          taking into account a maximum one, adn indenting the string.
    #          Code lines (i.e. indented by four spaces) are not wrapped.
    #
    # @param   [String] string
    #        The string to format.
    #
    # @param    [Fixnum] indent
    #          The number of spaces to insert before the string.
    #
    # @param   [Fixnum] max_width
    #         The maximum width to use to format the string if the terminal
    #         is too wide.
    #
    def self.wrap_foramtted_text(string, indent = 0, max_width = 80)
      paragraphs = strip_heredoc(string).split("\n\n")
      paragraphs = paragraphs.map do |paragraph|
        if paragraph.start_with?(' ' * 4)
          paragraphs.gsub!(/\n/, "\n#{' ' * indent}")
        else
          paragraph = wrap_with_indent(paragraph, indent, max_width)
        end
        paragraph.insert(0, ' ' * indent).rstrip
      end
      paragraphs.join("\n\n")
    end

    # @return [String] Wraps a string to the terminal width taking into
    #         account the given indentation.
    #
    # @param  [String] string
    #         The string to indent.
    #
    # @param  [Fixnum] indent
    #         The number of spaces to insert before the string.
    #
    # @param  [Fixnum] max_width
    #         The maximum width to use to format the string if the terminal
    #         is too wide.
    #
    def self.wrap_with_indent(string, indent = 0, max_width = 80)
      if terminal_width == 0
        width = max_width
      else
        width = [terminal_width, max_width].min
      end

      full_line = string.gsub("\n", ' ')
      available_width = width - indent
      space = ' ' * indent
      word_wrap(full_line, available_width).split("\n").join("\n#{space}")
    end

    # @return [String] Lifted straigth from Actionview. Thanks Guys!
    #
    def self.word_wrap(line, line_width)
      line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip
    end

    # @return [String] Lifted straigth from Actionview. Thanks Guys!
    #
    def self.strip_heredoc(string)
      if min = string.scan(/^[ \t]*(?=\S)/).min
        string.gsub(/^[ \t]{#{min.size}}/, '')
      else
        string
      end
    end

    # @!group Private helpers
    #---------------------------------------------------------------------#

    # @return [Fixnum] The width of the current terminal unless being piped.
    #
    def self.terminal_width
      unless @terminal_width
        if !ENV['CORK_DISABLE_AUTO_WRAP'] &&
            STDOUT.tty? && system('which tput > /dev/null 2>&1')
          @terminal_width = `tput cols`.to_i
        else
          @terminal_width = 0
        end
      end
      @terminal_width
    end
  end
end
