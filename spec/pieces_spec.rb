require File.expand_path("../../lib/pieces", __FILE__)

describe Pawn do

  context "#moveset" do
    it "returns only the square directly in front of it" do
      pawn = Pawn.new(:white, [6,1])
      expect(pawn.moveset).to eq([5,1])
    end

    it 'knows that black pawns go down the board' do
      pawn = Pawn.new(:black, [1,4])
      expect(pawn.moveset).to eq([2,4])
    end
  end

end

describe Rook do

  context '#moveset' do
    it 'returns the column' do
      rook = Rook.new(:white, [7,1])
      expect(rook.moveset).to include([0,1])
      #,[5,1],[4,1],[3,1],[2,1],[1,1],[0,1]]
    end
    it 'returns the row' do
      rook = Rook.new(:white, [7,1])
      expect(rook.moveset).to include([7,8])
    end
  end
end
