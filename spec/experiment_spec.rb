require File.expand_path("../../lib/board", __FILE__)

describe Board do
  subject(:board) { Board.new }
    context 'with enemy directly in front' do
      context 'tries to move two squares forward' do
        it 'returns false' do
          board.move([1,1],[5,8])
          board.visualise
          expect(board.valid_move?([6,8], [4,8], :white)).to be_falsey
        end
      end
    end

end
