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
  end
end
