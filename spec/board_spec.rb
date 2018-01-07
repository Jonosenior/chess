require File.expand_path("../../lib/board", __FILE__)

describe Board do
  subject(:board) { Board.new }


  describe "#valid_move?" do

    context "on opening board" do

      context "given empty starting square" do
        it 'returns false' do
          expect(board.valid_move?([4,3], [4,4], :white)).to be_falsey
        end
      end

      context "given starting square outside the board" do
        it 'returns false' do
          expect(board.valid_move?([10,3], [11,3], :white)).to be_falsey
        end
      end

      context "given a target square outside the board" do
        it 'returns false' do
          expect(board.valid_move?([0,1], [-1,1], :white)).to be_falsey
        end
      end

      context "given same target and starting squares" do
        it 'returns false' do
          expect(board.valid_move?([1,2], [1,2], :black)).to be_falsey
        end
      end

      context "if asked to move white pawn forward one square" do
        it 'returns true' do
          expect(board.valid_move?([6,1], [5,1], :white)).to be_truthy
        end
      end

      context 'if asked to move black pawn forward one square' do
        it 'returns true' do
          expect(board.valid_move?([1,1], [2,1], :black)).to be_truthy
        end
      end

      context 'if asked to move pawn three steps forward' do
        it 'returns false' do
          expect(board.valid_move?([1,1],[4,1], :black)).to be_falsey
        end
      end

      context 'if white tries to move a black piece' do
        it 'returns false' do
          expect(board.valid_move?([1,1],[2,1],:white)).to be_falsey
        end
      end

      context 'if black tries to move a white piece' do
        it 'returns false' do
          expect(board.valid_move?([6,7],[5,7],:black)).to be_falsey
        end
      end

      context 'the knight' do
        context 'if asked to jump squares' do
          it 'returns true' do
            expect(board.valid_move?([0,2],[2,3],:black)).to be_truthy
          end
        end
      end

      context 'the queen' do
        context 'attacking the enemy king' do
          it 'returns true' do
            board.move([7,1],[5,5])
            board.delete_at([1,5])
            #board.visualise
            piece = board.return_piece_at([5,5])
            moveset = piece.moveset
            # puts "within moveset" if board.target_within_moveset?([0,5],moveset)
            # puts "route blocked" if board.route_blocked?([5,5],[0,5])
            # puts "intermediary_squares: #{board.intermediary_squares([5,5],[0,5])}"
            expect(board.valid_move?([5,5],[0,5],:white)).to be_truthy
            # puts board.return_piece_at([5,5]).class
          end
        end
      end


    end
  end

  describe '#move' do
    it 'creates a piece of same class as starting square on target square' do
      board.move([1,2],[2,2])
      expect(board.contents[2][2].class).to eq(Pawn)
    end

    it 'creates a new piece that knows its new location' do
      board.move([1,2],[2,2])
      expect(board.contents[2][2].location).to eq([2,2])
    end

    it 'creates a new piece of same colour as the one on starting square' do
      original_colour = board.contents[6][7].colour
      board.move([6,7],[5,7])
      expect(board.contents[5][7].colour).to eq(original_colour)

    end

    it 'empties the starting square' do
      board.move([6,7],[5,7])
      expect(board.contents[6][7]).to eq(' ')
    end

  end



  describe '#check?' do
    context 'opening board' do
      it 'returns false' do
        expect(board.check?([0,5],:black,:white)).to be_falsey
      end
    end

    context 'white king in check' do
      it 'returns true' do
        board.move([0,1],[6,5])
        expect(board.check?([7,5],:white,:black)).to be_truthy
      end
    end

    context 'black king in check' do
      context 'attacked by white bishop' do
        it 'returns true' do
          board.move([7,3],[2,7])
          board.delete_at([1,6])
          expect(board.check?([0,5],:black,:white)).to be_truthy
        end
      end
      context 'attacked by white queen' do
        it 'returns true' do
          #board.move([7,3],[2,7])
          board.move([7,4],[5,5])
          #board.delete_at([1,6])
          board.delete_at([1,5])
          # puts board.return_piece_at([5,5]).class
          # puts "#{board.return_piece_at([5,5]).moveset}"
          # board.visualise
          expect(board.check?([0,5],:black,:white)).to be_truthy
        end
      end
    end

  end



  describe 'checkmate?' do
    context 'king is in check' do
      context 'king can\'t move out of check' do
        it 'returns false' do
          board.move([7,3],[2,7])
          board.delete_at([1,6])
          expect(board.checkmate?(:black,:white)).to be_truthy
        end
      end

      context 'king can move out of check' do
        context 'and new square is unattacked' do
          it 'returns true' do
            board.move([7,3],[2,7])
            board.delete_at([1,6])
            board.delete_at([1,5])
            #board.visualise
            expect(board.checkmate?(:black,:white)).to be_falsey
          end
        end

        context 'but new position would also be in check' do
          it 'returns false' do
            board.move([7,3],[2,7])
            board.move([7,4],[5,5])
            board.delete_at([1,6])
            board.delete_at([1,5])
            #board.visualise
            expect(board.checkmate?(:black,:white)).to be_truthy
          end
        end
      end

    end
  end

  describe '#target_within_moveset?' do
    context 'passed 3d array' do
      moveset = [[[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]], [[2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [2, 8]]]

      context 'containing the target' do
        it 'returns true' do
          expect(board.target_within_moveset?([2,4], moveset)).to be_truthy
        end

        context 'with Queen attacking' do
          it 'returns true' do
            moveset = [[[0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5]], [[5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], [5, 8]], [[5, 5], [4, 6], [3, 7], [2, 8]], [[5, 5], [4, 4], [3, 3], [2, 2], [1, 1]], [[5, 5], [6, 4], [7, 3]], [[5, 5], [6, 6], [7, 7]]]
            expect(board.target_within_moveset?([0,5], moveset)).to be_truthy
          end
        end
      end

      context 'not containing the target' do
        it 'returns false' do
          moveset = [[[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]], [[2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [2, 8]]]
          expect(board.target_within_moveset?([5,5], moveset)).to be_falsey
        end
      end
    end

    context 'passed 2d array' do
      moveset = [[2, 3], [2, 1], [1, 4]]
      context 'containing the target' do
        it 'returns true' do
          expect(board.target_within_moveset?([2,3], moveset)).to be_truthy
        end
      end

      context 'not containing the target' do
        it 'returns false' do
          expect(board.target_within_moveset?([4,1], moveset)).to be_falsey
        end
      end
    end

    context 'passed array of one element' do
      moveset = [3,1]
      context 'equal to the target' do
        it 'returns true' do
          expect(board.target_within_moveset?([3,1], moveset)).to be_truthy
        end
      end
      context 'not equal to the target' do
        it 'returns false' do
          expect(board.target_within_moveset?([3,2], moveset)).to be_falsey
        end
      end
    end

  end

  describe '#intermediary_squares' do
    context 'given a rook' do
      context 'passed a target on the same column' do
        it 'returns all intermediary squares' do
          board.move([7,1],[5,5])
          #board.delete_at([1,5])
          #board.visualise
          piece = board.return_piece_at([5,5])
          #moveset = piece.moveset
          expect(board.intermediary_squares([5,5], [0,5])).to eq([[4,5], [3,5], [2,5], [1,5]])
        end
      end
    end
  end



# PRIVATE METHODS (IE, LIKELY TO BE PRIVATE:)

  describe '#delete_at' do
    it 'replaces a piece on the board with " "' do
      board.delete_at([1,2])
      expect(board.contents[1][2]).to eq(' ')
    end

  end

  describe '#create_new_piece_at' do
    it 'creates a new piece on an empty square' do
      pawn = Pawn.new(:white, [6,2])
      board.create_new_piece_at(pawn, [4,2])
      expect(board.contents[4][2].class).to eq(Pawn)
    end

  end

  describe "#empty_sq?" do
    it "returns true if square is empty" do
      expect(board.empty_sq?([4,3])).to be_truthy
    end

    it "returns false if square contains a piece" do
      expect(board.empty_sq?([6,3])).to be_falsey
    end
  end

  describe "outside_board?" do
    it "returns false if square is within the board" do
      expect(board.outside_board?([5,1])).to be_falsey
    end
  end





end


# [  X  , "0,1", "0,2", "0,3", "0,4", "0,5", "0,6", "0,7", "0,8"]
#
# [  X  , "1,1", "1,2", "1,3", "1,4", "1,5", "1,6", "1,7", "1,8"]
#
# [  X  , "2,1", "2,2", "2,3", "2,4", "2,5", "2,6", "2,7", "2,8"]
#
# [  X  , "3,1", "3,2", "3,3", "3,4", "3,5", "3,6", "3,7", "3,8"]
#
# [  X  , "4,1", "4,2", "4,3", "4,4", "4,5", "4,6", "4,7", "4,8"]
#
# [  X  , "5,1", "5,2", "5,3", "5,4", "5,5", "5,6", "5,7", "5,8"]
#
# [  X  , "6,1", "6,2", "6,3", "6,4", "6,5", "6,6", "6,7", "6,8"]
#
# [  X  , "7,1", "7,2", "7,3", "7,4", "7,5", "7,6", "7,7", "7,8"]
