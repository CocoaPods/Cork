require File.expand_path('../spec_helper', __FILE__)


module Cork
  describe Board do
    before do
      @output = StringIO.new
      @error = StringIO.new
      @board = Board.new(:out => @output, :err => @error)
    end

    describe '#initialize' do
      it 'disables verbose by default' do
        @board.should.not.be.verbose
      end

      it 'does not silence by default' do
        @board.should.not.be.silent
      end

      it 'uses ansi codes by default' do
        @board.should.be.ansi
      end

      it 'uses stdin by default for input' do
        @board.input.should == $stdin
      end

      it 'uses stdout by default for output' do
        @board = Board.new
        @board.out.should == $stdout
      end

      it 'uses stderr by default for errors' do
        @board = Board.new
        @board.err.should == $stderr
      end

      it 'allows specifying verbose' do
        board = Board.new(:verbose => true)
        board.should.be.verbose
      end

      it 'allows specifying silent' do
        board = Board.new(:silent => false)
        board.should.not.be.silent
      end

      it 'allows specifying ansi' do
        board = Board.new(:ansi => true)
        board.should.be.ansi
      end

      it 'allows specifying input' do
        board = Board.new(:input => $stdin)
        board.input.should == $stdin
      end

      it 'allows specifying out' do
        board = Board.new(:out => $stdout)
        board.out.should == $stdout
      end

      it 'allows specifying err' do
        board = Board.new(:err => $stderr)
        board.err.should == $stderr
      end
    end
    describe '#puts' do
      it 'outputs the given string with a new line' do
        @board.puts('abc')
        @output.string.should == "abc\n"
      end

      it 'calls out#puts with an empty string when not silent' do
        @board.out.expects(:puts).with('')
        @board.puts
      end

      it 'does not output given string when silent' do
        @board = Board.new(:silent => true)
        @board.puts('abc')
        @board.puts
        @output.string.should == ''
      end
    end

    describe '#print' do
      it 'outputs the given string when not silent' do
        @board.print('abc')
        @output.string.should == 'abc'
      end

      it 'does not output the given value when silent' do
        @board = Board.new(:silent => true)
        @board.print('abc')
        @output.string.should == ''
      end
    end

    describe '#gets' do
      it 'calls input#gets' do
        @board.input.expects(:gets).returns('abc')
        @board.gets.should == 'abc'
      end
    end

    describe '#warn' do
      it 'stores a warning message' do
        @board.warn('warning')
        @board.warnings.should == [{
          :message => 'warning',
          :actions => [],
          :verbose_only => false,
        }]
      end

      it 'allows passing an array of actions' do
        @board.warn('warning', %w(action1 action2))
        @board.warnings.should == [{
          :message => 'warning',
          :actions => %w(action1 action2),
          :verbose_only => false,
        }]
      end

      it 'allows specifying whether the warning is verbose only' do
        @board.warn('warning', %w(action1 action2), true)
        @board.warnings.should == [{
          :message => 'warning',
          :actions => %w(action1 action2),
          :verbose_only => true,
        }]
      end
    end

    describe '#info' do
      it 'prints the info message' do
        @board.info('abc')
        @output.string.should == "abc\n"
      end

      it 'indents information by indentation level when verbose is enabled' do
        @board = Board.new(:out => @output, :verbose => true)
        @board.info('abc')
        @output.string.should == "  abc\n"
      end

      it 'increments indentation level during execution of a given block' do
        @board.send(:indentation_level).should == 2

        @board.info('abc') do
          @board.send(:indentation_level).should == 4
        end

        @board.send(:indentation_level).should == 2
      end

      it 'makes titles within the info a message when verbose is enabled' do
        @board = Board.new(:out => @output, :verbose => true)
        @board.info('info') do
          @board.title('title')
        end

        @output.string.should == "  info\n    title\n"
      end
    end

    describe '#title' do
      it 'prints the title' do
        @board.title('abc')
        @output.string.should == "\nabc".yellow + "\n"
      end

      it 'does not use colors when ansi is disabled' do
        @board = Board.new(:out => @output, :ansi => false)
        @board.title('abc')
        @output.string.should == "\nabc\n"
      end

      it 'uses a different color for titles within a title' do
        @board.title('abc') do
          @board.title('subtitle')
        end
        @output.string.should == "\nabc".yellow + "\n" + \
          "\nsubtitle".green + "\n"
      end

      it 'increases the indentation during the execution of a given block' do
        @board.send(:indentation_level).should == 2
        @board.title('abc') do
          @board.send(:indentation_level).should == 4
        end
        @board.send(:indentation_level).should == 2
      end
    end

    describe '#path' do
      it 'creates a path relative to a given path' do
        path = @board.path('/lib/cork', Pathname('/lib'))
        path.should == '`cork`'
      end

      it 'creates a path relative to current working directory by default' do
        path = @board.path(Pathname.pwd + 'abc')
        path.should == '`abc`'
      end

      it 'returns an empty string when no path is given' do
        path = @board.path(nil)
        path.should == ''
      end
    end

    describe '#labeled' do
      it 'prints nothing if value is nil' do
        @board.labeled('label', nil)
        @output.string.should == ''
      end

      it 'prints label and value on one line if value is not an array' do
        @board.labeled('label', 'value', 12)
        @output.string.should == "  - label:    value\n"
      end

      it 'justifies the label' do
        @board.labeled('label', 'value', 30)
        @output.string.should == "  - label:#{' ' * 22}value\n"
      end

      it 'justifies the label with default justification' do
        @board.labeled('label', 'value')  # defaults to 12
        @output.string.should == "  - label:    value\n"
      end

      it 'uses the indentation level' do
        @board.instance_variable_set(:@indentation_level, 10)
        @board.labeled('label', 'value')
        @output.string.should == "#{' ' * 10}- label:    value\n"
      end

      it 'prints array values on separate lines' do
        @board.instance_variable_set(:@indentation_level, 10)
        @board.labeled('label', %w(value1 value2))
        @output.string.split("\n").should == [
          "#{' ' * 10}- label:",
          "#{' ' * 12}- value1",
          "#{' ' * 12}- value2",
        ]
      end
    end

    describe '#section' do
      it 'prints the title' do
        @board.section('abc')
        @output.string.should == "abc\n"
      end

      it 'outputs the title when verbose is enabled' do
        @board = Board.new(:out => @output, :err => @error, :verbose => true)
        @board.section('abc')
        @output.string.should == "\nabc".yellow + "\n"
      end

      it 'does not output titles for sub-sections' do
        @board.section('section') do
          @board.section('subsection')
        end

        @output.string.should == "section\n"
      end
    end

    describe '#notice' do
      it 'outputs the given string when not silent' do
        @board.notice('Hello World')
        @output.string.should == ("\n[!] Hello World".green + "\n")
      end

      it 'outputs the given string without color codes when ansi is disabled' do
        @board = Board.new(:out => @output, :ansi => false)
        @board.notice('Hello World')
        @output.string.should == "\n[!] Hello World\n"
      end
    end

    # describe '#wrap_with_indent' do
    #   it 'wrap_string with a default indentation of zero' do
    #     UI.indentation_level = 0
    #     UI.output.should == 0
    #   end
    #
    # it 'creates a first space the size of the string times the indentation' do
    #   UI.indentation_level = 0
    #   UI.output.should == ''
    # end
    # end

    describe '#print_warnings' do
      it 'prints the warning' do
        @board.warn('everything is wrong!')
        @board.print_warnings
        @error.string.should == ("\n[!] everything is wrong!".yellow + "\n")
      end

      it 'prints the warning without color when ANSI is disabled' do
        @board = Board.new(:err => @error, :ansi => false)
        @board.warn('everything is wrong!')
        @board.print_warnings
        @error.string.should == "\n[!] everything is wrong!\n"
      end

      it 'prints available actions for each warning' do
        @board.warn('warning', %w(action1 action2))
        @board.print_warnings
        @error.string.should == (
          "\n[!] warning".yellow +
          "\n    - action1\n    - action2\n"
        )
      end

      it "doesn't print a verbose warning when verbose is disabled" do
        @board.warn('everything is wrong!', [], true)
        @board.print_warnings
        @error.string.should == ''
      end

      it 'prints a verbose warning when verbose is enabled' do
        @board = Board.new(:err => @error, :ansi => false, :verbose => true)
        @board.warn('everything is wrong!', [], true)
        @board.print_warnings
        @error.string.should == "\n[!] everything is wrong!\n"
      end
    end
  end
end
