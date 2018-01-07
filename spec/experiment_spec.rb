require File.expand_path("../../lib/board", __FILE__)

describe Board do
  subject(:board) { Board.new }


    describe '#intermediary_squares' do
      context 'given a rook' do
        context 'passed a target on the same column' do
          it 'returns all intermediary squares' do
            board.move([7,1],[5,5])
            board.delete_at([1,5])
            board.visualise
            piece = board.return_piece_at([5,5])
            #moveset = piece.moveset
            expect(board.intermediary_squares([5,5], [0,5])).to eq([[4,5], [3,5], [2,5], [1,5]])
          end
        end
      end
    end
end
