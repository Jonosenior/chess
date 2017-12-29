require File.expand_path("../../lib/pieces", __FILE__)

describe Pawn do

  context "#moveset" do
    it "returns the square directly in front of it" do
      pawn = Pawn.new(:white, [6,1])
      expect(pawn.moveset).to eq([5,1])
    end
    
    # it "returns no other squares" do
    # end

  end

end
