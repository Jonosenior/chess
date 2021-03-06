require File.expand_path("../../lib/board", __FILE__)
require 'pry'

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

    context 'the pawn' do
      context 'colour: white' do
        context 'on opening board' do
          context 'tries to move 2 squares forward' do
            it 'returns true' do
              expect(board.valid_move?([6,3],[4,3],:white)).to be_truthy
            end
          end
          context 'tries to move 1 square forward' do
            it 'returns true' do
              expect(board.valid_move?([6,3],[5,3],:white)).to be_truthy
            end
          end
          context 'tries to move 3 squares' do
            it 'returns false' do
              expect(board.valid_move?([6,3],[3,3],:white)).to be_falsey
            end
          end
          context 'tries to move diagonally right' do
            it 'returns false' do
              expect(board.valid_move?([6,3],[5,4],:white)).to be_falsey
            end
          end
          context 'tries to move diagonally left' do
            it 'returns false' do
              expect(board.valid_move?([6,3],[5,2],:white)).to be_falsey
            end
          end
        end #opening board
        context 'with enemy directly in front' do
          context 'tries to move two squares forward' do
            it 'returns false' do
              board.move([1,1],[5,8])
              expect(board.valid_move?([6,8],[4,8],:white)).to be_falsey
            end
          end
          context 'tries to move one square forward' do
            it 'returns false' do
              board.move([1,1],[5,8])
              expect(board.valid_move?([6,8],[5,8],:white)).to be_falsey
            end
          end
          context 'tries to move diagonally to empty square' do
            it 'returns false' do
              board.move([1,1],[5,8])
              expect(board.valid_move?([6,8],[5,7],:white)).to be_falsey
            end
          end#move diagonally
        end # enemy
        context 'tries to attack friendly piece' do
          it 'returns false' do
            board.move([7,2],[5,3])
            #board.visualise
            expect(board.valid_move?([6,2],[5,3],:white)).to be_falsey
          end
        end
        context 'tries to attack enemy piece' do
          it 'returns true' do
            board.move([0,3],[5,3])
            #board.visualise
            expect(board.valid_move?([6,2],[5,3],:white)).to be_truthy
          end
        end
      end #white

      context 'colour: black' do
        context 'on opening board' do
          context 'tries to move 2 squares forward' do
            it 'returns true' do
              expect(board.valid_move?([1,1],[3,1],:black)).to be_truthy
            end
          end
          context 'tries to move 1 square forward' do
            it 'returns true' do
              expect(board.valid_move?([1,3],[2,3],:black)).to be_truthy
            end
          end
          context 'tries to move 3 squares' do
            it 'returns false' do
              expect(board.valid_move?([1,8],[4,8],:black)).to be_falsey
            end
          end
          context 'tries to move diagonally right into empty square' do
            it 'returns false' do
              expect(board.valid_move?([1,5],[2,6],:black)).to be_falsey
            end
          end
          context 'tries to move diagonally left' do
            it 'returns false' do
              expect(board.valid_move?([1,5],[2,4],:black)).to be_falsey
            end
          end
        end #opening board
        context 'with enemy directly in front' do
          context 'tries to move two squares forward' do
            it 'returns false' do
              board.move([6,1],[2,4])
              expect(board.valid_move?([1,4],[3,4],:black)).to be_falsey
            end
          end
          context 'tries to move one square forward' do
            it 'returns false' do
              board.move([6,1],[2,4])
              expect(board.valid_move?([1,4],[2,4],:black)).to be_falsey
            end
          end
          context 'tries to move diagonally to empty square' do
            it 'returns false' do
              board.move([6,1],[2,4])
              expect(board.valid_move?([1,4],[2,5],:black)).to be_falsey
            end
          end#move diagonally
        end # enemy
        context 'tries to attack friendly piece' do
          it 'returns false' do
            board.move([0,1],[2,3])
            #board.visualise
            expect(board.valid_move?([1,4],[2,3],:black)).to be_falsey
          end
        end
        context 'tries to attack enemy piece' do
          it 'returns true' do
            board.move([7,8],[2,7])
            #board.visualise
            expect(board.valid_move?([1,8],[2,7],:black)).to be_truthy
          end
        end
      end #black

      context 'king is in check' do
        context 'king can\'t move away' do
          context 'user doesn\'t move out of check' do
            it 'returns false' do
              board.move([0,4],[5,5])
              board.delete_at([6,5])
              expect(board.valid_move?([6,1],[5,1],:white)).to be_falsey
              #board.visualise
            end
          end
          context 'user moves king into check' do
            it 'returns false' do
              board.move([0,4],[5,5])
              board.delete_at([6,5])
              expect(board.valid_move?([7,5],[6,5],:white)).to be_falsey
              #board.visualise
            end
          end
          context 'user captures attacker' do
            it 'returns true' do
              board.move([0,4],[5,5])
              board.delete_at([6,5])
              expect(board.valid_move?([6,4],[5,5],:white)).to be_truthy
              #board.visualise
            end
          end
          context 'user\'s move blocks the attack' do
            it 'returns true' do
              board.move([0,4],[5,5])
              board.delete_at([6,5])
              expect(board.valid_move?([7,6],[6,5],:white)).to be_truthy
              #board.visualise
            end
          end
          context 'user\'s king captures attacker' do
            context 'without putting itself in check' do
              it 'returns true' do
                board.move([0,4],[6,5])
                expect(board.valid_move?([7,5],[6,5],:white)).to be_truthy
              #  board.visualise
              end
            end
            context 'but puts itself in check' do
              it 'returns false' do
                board.move([0,4],[6,5])
                board.move([0,8],[2,5])
                expect(board.valid_move?([7,5],[6,5],:white)).to be_falsey
                #board.visualise
              end
            end
          end
        end
        context 'king is not directly in check' do
          context 'but moves into check' do
            it 'returns false' do
              board.move([7,6],[3,7])
              board.delete_at([1,5])
              expect(board.valid_move?([0,5],[1,5],:black)).to be_falsey
              #board.visualise
            end
          end
          context 'but defender moves away, leaving him in check' do
            it 'returns false' do
              board.move([7,6],[2,7])
              expect(board.valid_move?([1,6],[2,6],:black)).to be_falsey
              #board.visualise
            end
          end
        end
      end

    end

    context 'the king' do
      context 'not in check' do
        context 'user tries to castle kingside' do
          context 'with two empty spaces kingside' do
            it 'returns true' do
              board.delete_at([7,6])
              board.delete_at([7,7])
              # board.visualise
              expect(board.valid_move?([7,5],[7,7],:white)).to be_truthy
            end # it
            context 'king has already moved' do
              it 'returns false' do
                board.delete_at([7,6])
                board.delete_at([7,7])
                board.move([7,5],[7,6])
                board.move([7,6],[7,5])
                # board.visualise
                expect(board.valid_move?([7,5],[7,7],:white)).to be_falsey
              end
            end
          end # two empty spaces kingside
        end # castle kingside
        context 'user tries to castle queenside' do
          context 'with three empty spaces queenside' do
            context 'with no part of route in check' do
              it 'returns true' do
                board.delete_at([7,4])
                board.delete_at([7,3])
                board.delete_at([7,2])
                # board.visualise
                expect(board.valid_move?([7,5],[7,3],:white)).to be_truthy
              end #it
            end # route not in check
            context 'but one square of route is in check' do
              it 'returns false' do
                board.delete_at([7,4])
                board.delete_at([7,3])
                board.delete_at([7,2])
                board.delete_at([6,3])
                board.move([0,1],[2,3])
                # board.visualise
                expect(board.valid_move?([7,5],[7,3],:white)).to be_falsey
              end
            end
            context 'rook is in check but route isn\'t' do
              it 'returns true' do
                board.delete_at([7,4])
                board.delete_at([7,3])
                board.delete_at([7,2])
                board.delete_at([6,1])
                board.move([0,1],[2,1])
                # board.visualise
                expect(board.valid_move?([7,5],[7,3],:white)).to be_truthy
              end
            end
            context 'rook has already moved' do
              it 'returns false' do
                board.delete_at([7,4])
                board.delete_at([7,3])
                board.delete_at([7,2])
                board.move([7,1],[7,2])
                board.move([7,2],[7,1])
                # board.visualise
                expect(board.valid_move?([7,5],[7,3],:white)).to be_falsey
              end
            end
          end # three empty spaces queenside
        end
      end # not in check
      context 'king is in check' do
        it 'returns false' do
          board.delete_at([6,5])
          board.delete_at([7,6])
          board.delete_at([7,7])
          board.move([0,4],[2,5])
          # board.visualise
          expect(board.valid_move?([7,5],[7,7],:white)).to be_falsey
        end
      end
      context 'black king' do
        context 'user tries to castle queenside' do
          it 'returns true' do
            board.delete_at([0,4])
            board.delete_at([0,3])
            board.delete_at([0,2])
            # board.visualise
            expect(board.valid_move?([0,5],[0,3],:black)).to be_truthy
          end
        end
        context 'user tries to castle kingside' do
          it 'returns true' do
            board.delete_at([0,6])
            board.delete_at([0,7])
            # board.visualise
            expect(board.valid_move?([0,5],[0,7],:black)).to be_truthy
          end
        end
      end
    end # the king

  end # valid_move

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



  describe '#piece_under_attack?' do
    context 'opening board' do
      it 'returns false' do
        black_king = board.locate_piece(King, :black)
        expect(board.piece_under_attack?(black_king)).to be_falsey
      end
    end

    context 'white king in check' do
      it 'returns true' do
        white_king = board.locate_piece(King, :white)
        board.move([0,1],[6,5])
        expect(board.piece_under_attack?([7,5])).to be_truthy
      end
    end

    context 'black king in check' do
      context 'attacked by white bishop' do
        it 'returns true' do
          black_king = board.locate_piece(King, :black)
          board.move([7,3],[2,7])
          board.delete_at([1,6])
          expect(board.piece_under_attack?(black_king)).to be_truthy
        end
      end

      context 'attacked by white queen' do
        it 'returns true' do
          black_king = board.locate_piece(King, :black)
          board.move([7,4],[5,5])
          board.delete_at([1,5])
          expect(board.piece_under_attack?(black_king)).to be_truthy
        end
      end
    end

  end



  describe 'checkmate?' do
    context 'king is in check' do

      context 'king can\'t move out of check' do
        it 'returns true' do
          board.move([7,3],[2,7])
          board.delete_at([1,6])
          board.delete_at([1,7])
          board.delete_at([1,8])
          # attackers = board.locate_attackers([0,5])
          # puts "Attackers: #{attackers}"
          # puts "Piece under attack? #{board.piece_under_attack?(attackers.flatten)}"
          #board.visualise
          expect(board.checkmate?(:black)).to be_truthy
        end
      end

      context 'king can move out of check' do
        context 'and new square is unattacked' do
          it 'returns false' do
            board.move([7,3],[2,7])
            board.delete_at([1,6])
            board.delete_at([1,5])
            #board.visualise
            expect(board.checkmate?(:black)).to be_falsey
          end
        end

        context 'but new position would also be in check' do
          it 'returns true' do
            board.move([7,3],[2,7])
            board.move([7,4],[5,5])
            board.delete_at([1,8])
            board.delete_at([1,6])
            board.delete_at([1,5])
            #board.visualise
            expect(board.checkmate?(:black)).to be_truthy
          end
        end
      end

      context 'by single attacker' do
        context 'and king can\'t move out of check'
          context 'but attacker can be captured' do
            it 'returns false' do
              board.move([7,7],[2,6])
              #board.move([7,4],[5,5])
              #board.delete_at([1,6])
              #board.delete_at([1,5])
              #board.visualise
              #puts "#{board.piece_under_attack?([2,6])}"

              expect(board.checkmate?(:black)).to be_falsey
            end
          end
          context 'and attacker can\'t be captured' do
            context 'and attack can\'t be blocked' do
              it 'returns true' do
                board.move([7,4],[2,7])
                board.delete_at([1,8])
                board.delete_at([1,6])
                board.delete_at([1,7])
                #board.visualise
                expect(board.checkmate?(:black)).to be_truthy
              end
            end
            context 'but attack can be blocked' do
              it 'returns false' do
                board.move([7,4],[2,7])
                board.move([0,8],[0,6])
                board.delete_at([1,8])
                board.delete_at([1,6])
                board.delete_at([1,7])
                #board.visualise
                expect(board.checkmate?(:black)).to be_falsey
              end
            end
          end


        context 'knight threatens king' do
          context 'king can\'t move to escape' do
            context 'knight can\'t be captured' do
              it 'returns true' do
                board.move([0,2],[6,7])
                board.move([7,8],[7,6])
                #board.visualise
                expect(board.checkmate?(:white)).to be_truthy
              end
            end
            context 'knight can be captured' do
              it 'returns false' do
                board.move([0,2],[6,7])
                #board.visualise
                expect(board.checkmate?(:white)).to be_falsey
              end
            end #/captured
          end #/can't move to escape
          context 'king can move to escape' do
            it 'returns false' do
              board.move([0,2],[6,7])
              board.move([7,8],[7,6])
              board.delete_at([7,4])
              #board.visualise
              expect(board.checkmate?(:white)).to be_falsey
            end
          end
        end
      end
    end
  end

  describe '#stalemate?' do
    context 'king is in check' do
      it 'returns false' do
        (0..7).each {|x| (1..8).each {|y| board.delete_at([x,y])}}
        board.contents[0][1] = King.new(:black,[0,1])
        board.contents[0][5] = Rook.new(:white,[0,5])
        board.contents[5][3] = King.new(:white,[5,3])
        expect(board.stalemate?(:white)).to be_falsey
      end
    end
    context 'king is in checkmate' do
      it 'returns false' do
        board.move([0,2],[6,7])
        board.move([7,8],[7,6])
        #board.visualise
        expect(board.stalemate?(:white)).to be_falsey
      end
    end
    context 'king is not in check' do
      context 'and all its moves would be check' do
        context 'and there are no other pieces' do
          it 'returns true' do
            (0..7).each {|x| (1..8).each {|y| board.delete_at([x,y])}}
            board.contents[0][1] = King.new(:black,[0,1])
            board.contents[1][5] = Rook.new(:white,[1,5])
            board.contents[4][2] = Rook.new(:white,[4,2])
            board.contents[5][3] = King.new(:white,[5,3])
            #board.visualise
            expect(board.stalemate?(:white)).to be_truthy
          end
        end
        context 'but there is another friendly piece' do
          context  'which can move' do
            it 'returns false' do
              (0..7).each {|x| (1..8).each {|y| board.delete_at([x,y])}}
              board.contents[0][1] = King.new(:black,[0,1])
              board.contents[1][5] = Rook.new(:white,[1,5])
              board.contents[4][2] = Rook.new(:white,[4,2])
              board.contents[5][3] = King.new(:white,[5,3])
              board.contents[1][7] = Pawn.new(:black,[1,7])
              #board.visualise
              expect(board.stalemate?(:white)).to be_falsey
            end
          end
          context 'but it can\'t move without putting king in check' do
            it 'returns true' do
                (0..7).each {|x| (1..8).each {|y| board.delete_at([x,y])}}
                board.contents[0][1] = King.new(:black,[0,1])
                board.contents[1][3] = Bishop.new(:white,[1,3])
                board.contents[2][3] = Bishop.new(:white,[2,3])
                board.contents[2][2] = King.new(:white,[2,2])
                board.contents[1][2] = Knight.new(:black,[1,2])
                #board.visualise
                expect(board.stalemate?(:white)).to be_truthy
            end
          end
        end
      end
      # context 'and it can move out of check'
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

  describe '#pawn_to_promote' do
    context 'white pawn moves to last row (contents[0])' do
      it 'returns true' do
        board.delete_at([1,1])
        board.move([6,1],[0,1])
        expect(board.pawn_to_promote?(:white)).to be_truthy
      end
      it 'returns false for black' do
        board.delete_at([1,1])
        board.move([6,1],[0,1])
        expect(board.pawn_to_promote?(:black)).to be_falsey
      end
    end
  end

  describe '#promote' do
    context 'white pawn is on last row' do
      it 'deletes pawn' do
        board.delete_at([1,1])
        board.move([6,1],[0,1])
        board.promote(Queen,:white)
        expect(board.contents[0].any? {|a| a.class == Pawn}).to be_falsey
      end
      context 'passed a new_class of Queen' do
        it 'creates a Queen' do
          board.delete_at([1,1])
          board.move([6,1],[0,1])
          board.promote(Queen,:white)
          expect(board.contents[0].count {|a| a.class == Queen}).to eq(2)
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
