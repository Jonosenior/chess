require File.expand_path("../../lib/board", __FILE__)

describe Board do
  subject(:board) { Board.new }


  context "#valid_move?" do
    it "returns false if the starting square is empty" do
      expect(board.valid_move?([4,3], [4,4])).to be_falsey
    end

    it 'returns false if starting square is outside the board' do
      expect(board.valid_move?([10,3], [11,3])).to be_falsey
    end

    it 'returns false if target square is outside the board' do
      expect(board.valid_move?([0,1], [-1,1])).to be_falsey
    end

    it 'returns true if white pawn asked to move forward one square' do
      expect(board.valid_move?([6,1], [5,1], :white)).to be_truthy
    end

    it 'returns true if black pawn asked to move forward one square' do
      expect(board.valid_move?([1,1], [2,1], :black)).to be_truthy
    end

    it 'returns false if asked to move pawn three steps forward' do
      expect(board.valid_move?([1,1],[4,1])).to be_falsey
    end

    it 'returns false if white tries to move a black piece' do
      expect(board.valid_move?([1,1],[2,1],:white)).to be_falsey
    end

    it 'returns false if black tries to move a white piece' do
      expect(board.valid_move?([6,7],[5,7],:black)).to be_falsey
    end
  end

  context '#move' do
    it 'creates a piece of same class as starting square on target square' do
      board.move([1,2],[2,2])
      expect(board.contents[2][2].class).to eq(Pawn)
    end

    it 'creates a new piece that knows its new location' do
      board.move([1,2],[2,2])
      expect(board.contents[2][2].location).to eq([2,2])
    end

    it 'creates a new piece of same colour as the one on starting square' do
      board.
    end

    it 'empties the starting square' do
      board.move([6,7],[5,7])
      expect(board.contents[6][7]).to eq(' ')
    end

  end



# PRIVATE METHODS (IE, LIKELY TO BE PRIVATE:)

  context '#delete_at' do
    it 'replaces a piece on the board with " "' do
      board.delete_at([1,2])
      expect(board.contents[1][2]).to eq(' ')
    end

  end

  context '#create_new_piece_at' do
    it 'creates a new piece on an empty square' do
      pawn = Pawn.new(:white, [6,2])
      board.create_new_piece_at(pawn, [4,2])
      expect(board.contents[4][2].class).to eq(Pawn)
    end

  end

  context "#empty_sq?" do
    it "returns true if square is empty" do
      expect(board.empty_sq?([4,3])).to be_truthy
    end

    it "returns false if square contains a piece" do
      expect(board.empty_sq?([6,3])).to be_falsey
    end
  end

  context "outside_board?" do
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
