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
    end

    describe '#puts' do
      it 'calls out#puts when not silent' do
        @board.out.expects(:puts).with('abc')
        @board.puts('abc')
      end

      it 'call out#puts with an empty string when not silent' do
        @board.out.expects(:puts).with('abc')
        @board.puts('abc')
      end
    end
  end
end


      it does not call out#puts when silent
