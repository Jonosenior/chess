require_relative 'pieces'

class Board

  #attr_reader :contents
  def initialize
    @contents = [[' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
              #  ['8',  Rook.new(:black, [1,1]), Knight.new(:black, [1,2]),
              #  Bishop.new(:black, [1,3]),	Queen.new(:black, [1,4]), King.new(:black, [1,5]),
              #  Bishop.new(:black, [1,6]),	Knight.new(:black, [1,7]), Rook.new(:black, [1,8])],
              ['7',  Pawn.new(:black, [2,1]), Pawn.new(:black, [2,2]),
               Pawn.new(:black, [2,3]),	Pawn.new(:black, [2,4]), Pawn.new(:black, [2,5]),
               Pawn.new(:black, [2,6]),	Pawn.new(:black, [2,7]), Pawn.new(:black, [2,8])],
               ['6',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['5',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['4',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['3',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['2',  Pawn.new(:white, [7,1]), Pawn.new(:white, [7,2]),
               Pawn.new(:white, [7,3]), Pawn.new(:white, [7,4]), Pawn.new(:white, [7,5]),
               Pawn.new(:white, [7,6]), Pawn.new(:white, [7,7]), Pawn.new(:white, [7,8])],
              #  ['1',  Rook.new(:white, [8,1]), Knight.new(:white, [8,2]),
              #  Bishop.new(:white, [8,3]), Queen.new(:white, [8,4]), King.new(:white, [8,5]),
              #  Bishop.new(:white, [8,6]), Knight.new(:white, [8,7]), Rook.new(:white, [8,8])]
                ]
  end




  def show_board
		@contents.map do |line|
			puts line.map { |square| square =~ /\w|\s/ ? square.center(3) : square.icon.center(3) }.join(" ")
      puts #'   ├────┼────┼────┼────┼────┼────┼────┼────┤'

		end
	end

end

@board = Board.new
#@board.contents
@board.show_board
