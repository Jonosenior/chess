require File.expand_path("../../lib/pieces", __FILE__)

describe Pawn do

  describe "#moveset" do
    context 'white pawn' do
      context 'on its first move' do
        subject(:pawn) {Pawn.new(:white, [6,2], true)}
          context 'with an empty square in front' do
            it 'can move two squares forward' do
              expect(pawn.moveset).to include([4,2])
            end
            it 'can move one square forward' do
              expect(pawn.moveset).to include([4,2])
            end
          end  #empty square in front

          context 'with an enemy piece diagonally in front' do
            it 'can move diagonally left' do
              expect(pawn.moveset).to include([5,1])
            end
            it 'can move diagonally right' do
              expect(pawn.moveset).to include([5,3])
            end
          end
      end #/on its first move
      context 'in the middle of the board' do
        subject(:pawn) {Pawn.new(:white, [3,4], true)}
        it 'cannot move backwards' do
          expect(pawn.moveset).not_to include([4,4])
        end
      end
    end #/white pawn
    # it "returns only the square directly in front of it" do
    #   pawn = Pawn.new(:white, [6,1])
    #   expect(pawn.moveset).to eq([5,1])
    # end
    #
    # it 'knows that black pawns go down the board' do
    #   pawn = Pawn.new(:black, [1,4])
    #   expect(pawn.moveset).to eq([2,4])
    # end
  end

end

describe Rook do

  describe '#moveset' do

    it 'returns the same column as location' do
      rook = Rook.new(:white, [7,1])
      expect(rook.moveset.flatten(1)).to include([0,1])
      #,[5,1],[4,1],[3,1],[2,1],[1,1],[0,1]]
    end
    it 'returns the same row as location' do
      rook = Rook.new(:white, [7,1])
      expect(rook.moveset.flatten(1)).to include([7,8])
    end

    it 'doesn\'t return a diagonal' do
      rook = Rook.new(:black, [0,1])
      expect(rook.moveset).not_to include([1,2])
    end
  end
end

describe Knight do

  describe '#moveset' do
    context 'located on a central square' do
      subject(:knight) {Knight.new(:white, [4,5])}

      it 'returns 8 squares' do
        expect(knight.moveset.length).to eq(8)
      end

      it 'returns correct squares' do
        expect(knight.moveset).to include([3,3],[2,4],[5,3],[6,4],[6,6],[5,7],[3,7],[2,6])
      end
    end

    context 'located on a corner square' do
      subject(:knight) {Knight.new(:black, [0,1])}

      it 'returns 2 squares' do
        expect(knight.moveset.length).to eq(2)
      end

      it 'returns the correct squares' do
        expect(knight.moveset).to include([1,3],[2,2])
      end
    end

    context 'located on starting square' do
      context 'black knight' do
        subject(:knight) {Knight.new(:black, [0,2])}

          it 'returns correct squares' do
            expect(knight.moveset).to include([2,1],[2,3],[1,4])
          end
      end
    end

  end
end

describe Bishop do

  describe '#moveset' do
    context 'located in a corner' do
      subject(:bishop) { Bishop.new(:black, [0,1]) }

      it 'doesn\'t return a square on the same column' do
        expect(bishop.moveset.flatten(1)).not_to include([1,1])
      end

      it 'doesn\'t return a square on the same row' do
        expect(bishop.moveset.flatten(1)).not_to include([0,2])
      end

      it 'returns a square on the same diagonal' do
        expect(bishop.moveset.flatten(1)).to include([7,8])
      end
    end

    context 'located in a central square' do
      subject(:bishop) { Bishop.new(:white, [4,5]) }

      it 'returns a square in the top right diagonal' do
        expect(bishop.moveset.flatten(1)).to include([1,8])
      end

      it 'returns a square in the top left diagonal' do
        expect(bishop.moveset.flatten(1)).to include([1,8])
      end

      it 'returns a square in the bottom left diagonal' do
        expect(bishop.moveset.flatten(1)).to include([7,2])
      end

      it 'returns a square in the bottom right diagonal' do
        expect(bishop.moveset.flatten(1)).to include([6,7])
      end
    end
  end
end

describe King do

  describe '#moveset' do
    context 'after first move' do
      context 'located on a central square' do
        subject(:king) {King.new(:white, [4,4])}

        it 'returns 8 squares' do
          expect(king.moveset.length).to eq(8)
        end

        it 'cannot move two squares' do
          expect(king.moveset).not_to include([4,6])
        end
      end

      context 'located on a corner square' do
        subject(:king) {King.new(:black, [0,8])}

        it 'returns 3 squares' do
          expect(king.moveset.length).to eq(3)
        end
      end
    end

    context 'it has not yet moved' do
      subject(:king) {King.new(:black, [0,5], true)}
      it 'can move two squares kingside to castle' do
        expect(king.moveset).to include([0,7])
      end

      it 'can move two squares queenside' do
        expect(king.moveset).to include([0,3])
      end
    end




  end
end

describe Queen do

    describe '#moveset' do

      context 'located in a corner' do
        subject(:queen) { Queen.new(:black, [0,1]) }

        it 'returns a square on the same diagonal' do
          expect(queen.moveset.flatten(1)).to include([7,8])
        end
      end

      context 'located in a central square' do
        subject(:queen) { Queen.new(:white, [4,5]) }

        it 'returns a square in the top right diagonal' do
          expect(queen.moveset.flatten(1)).to include([1,8])
        end

        it 'returns a square in the top left diagonal' do
          expect(queen.moveset.flatten(1)).to include([1,8])
        end

        it 'returns a square in the bottom left diagonal' do
          expect(queen.moveset.flatten(1)).to include([7,2])
        end

        it 'returns a square in the bottom right diagonal' do
          expect(queen.moveset.flatten(1)).to include([6,7])
        end
      end
  end
end
