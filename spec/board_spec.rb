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
        board =Board.new(:input => $stdin)
        board.stdin.should == $stdin
      end

      it 'allows specifying out' do
        board = Board.new(:out => $stdout)
        board.stdout.shoud == $stdout
      end

      it 'allows specifying err' do
        board = Board.new(:err => $stderr)
        board.stderr.should == $stderr
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
        @board.print
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

    #---Check These Tests with Samuel. @param test are challenging--#

#---  describe '#initialize' do----#
      it 'allows passing an array of strings' do
        board = Board.new(:param => [String])
        board.should.be.passing.an.array.of.strings
      end

      it 'allows passing an array of arrays' do
        board = Board.new(:param => [Array])
        board.should.be.passing.an.array.of.arrays
      end
  #---  end --- move 88-97 into the initialize block at the top --- #

    describe '#warn' do
      it 'does store and print a warning message' do
        @board.should.be.printing.a.warning
      end
    end
  end
end



    #---  it 'does not call out#puts when silent' do ----#
