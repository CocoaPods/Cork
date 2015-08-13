require File.expand_path('../spec_helper', __FILE__)

module Cork
  describe Board do
    before do
      @board = Board.new
    end

    describe '#initialize' do
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
      it 'calls out#puts when not silent' do
        @board.out.expects(:puts).with('abc')
        @board.puts('abc')
      end

      it 'calls out#puts with an empty string when not silent' do
        @board.out.expects(:puts).with('abc')
        @board.puts('abc')
      end

      it 'does not call out#puts when silent' do
        @board.stubs(:silent?).returns(true)
        @board.out.expects(:puts).never
        @board.puts('abc')
        @board.puts
      end
    end

    describe '#print' do
      it 'calls out#print when not silent' do
        @board.out.expects(:print).with('abc')
        @board.print('abc')
      end

      it 'does not call out#print when silent' do
        @board.stubs(:silent?).returns(true)
        @board.out.expects(:print).never
        @board.print('abc')
      end
    end

    describe '#gets' do
      it 'calls input#gets' do
        @board.input.expects(:gets).returns('abc')
        @board.gets.should == 'abc'
      end

      it 'does not call input#gets' do
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
  end
end
#---Check These Tests with Samuel. @param test are challenging--#
#---  it 'does not call out#puts when silent' do ----#
