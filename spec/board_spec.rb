require File.expand_path("../../lib/board", __FILE__)

describe Board do
  subject(:board) { Board.new }


  context "#empty_sq?" do
    it "returns true if square is empty" do
      expect(board.empty_sq?([4,3])).to be_truthy
    end

    it "returns false if square contains a piece" do
      expect(board.empty_sq?([6,3])).to be_falsey
    end
  end

  context "#valid_move?" do
    it "returns false if the starting square is empty" do
      expect(board.valid_move?([4,3], [4,4])).to be_falsey
    end
  end

  
end
