require_relative 'pieces'

class Board

  attr_reader :contents

  def initialize
    @contents =
              [['8',  Rook.new(:black, [1,1]), Knight.new(:black, [1,2]),
                Bishop.new(:black, [1,3]),	Queen.new(:black, [1,4]), King.new(:black, [1,5]),
                Bishop.new(:black, [1,6]),	Knight.new(:black, [1,7]), Rook.new(:black, [1,8])],
              ['7',  Pawn.new(:black, [1,1]), Pawn.new(:black, [1,2]),
               Pawn.new(:black, [1,3]),	Pawn.new(:black, [1,4]), Pawn.new(:black, [1,5]),
               Pawn.new(:black, [1,6]),	Pawn.new(:black, [1,7]), Pawn.new(:black, [1,8])],
               ['6',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['5',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['4',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['3',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['2',  Pawn.new(:white, [6 ,1]), Pawn.new(:white, [6,2]),
               Pawn.new(:white, [6,3]), Pawn.new(:white, [6,4]), Pawn.new(:white, [6,5]),
               Pawn.new(:white, [6,6]), Pawn.new(:white, [6,7]), Pawn.new(:white, [6,8])],
                ['1',  Rook.new(:white, [8,1]), Knight.new(:white, [8,2]),
                Bishop.new(:white, [8,3]), Queen.new(:white, [8,4]), King.new(:white, [8,5]),
                Bishop.new(:white, [8,6]), Knight.new(:white, [8,7]), Rook.new(:white, [8,8])]]
  end


  public

  def visualise
    puts "\n\n\n"
    puts [' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map {|square| square.center(3)}.join(" ") + "\n\n"
		@contents.map do |line|
			puts line.map { |square| square =~ /\w|\s/ ? square.center(3) : square.icon.center(3) }.join(" ")
      puts #'   ├────┼────┼────┼────┼────┼────┼────┼────┤'
		end
	end

  def move(start, target)
    piece = return_piece_at(start)
    create_new_piece_at(piece, target)
    delete_at(start)
  end

  def valid_move?(start, target, player_colour=nil)
    return false if outside_board?(start) || outside_board?(target)
    return false if empty_sq?(start)
    return false if start == target
    piece = return_piece_at(start)
    return false if player_colour != piece.colour
    return false if !target_within_moveset?(start, target, piece)
    return false if friendly_fire?(piece, target)
    return false if route_blocked?(start, target)
    true
  end

  #private

  def route_blocked?(start, target)
    route = intermediary_squares(start, target)
    return true if route.any? {|square| return_piece_at(square) != ' '}
    false
  end

  def intermediary_squares(start, target)
    #moveset = [[[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]], [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8]]]
    moveset = return_piece_at(start).moveset
    line = moveset.select {|a| a.include?(target)}.flatten(1)
    start_index = line.index(start)
    target_index = line.index(target)
    line = line.reverse if start_index > target_index
    route = line[start_index+1...target_index]

    # puts "#{line}"
    # puts "#{start_index}"
    # puts "#{target_index}"
    # puts "#{route}"
  end

  def delete_at(sq)
    @contents[sq[0]][sq[1]] = ' '
  end

  def create_new_piece_at(piece, square)
    @contents[square[0]][square[1]] = (piece.class).new(piece.colour, square)
  end

  def friendly_fire?(piece, target)
    !empty_sq?(target) && piece.colour == target.colour
  end

  def target_within_moveset?(start, target, piece)
    piece.moveset.each {|a| a.include?(target) || a.include?(target) }
    #piece.moveset.include?(target) || piece.moveset == target
  end

  def return_piece_at(sq)
    @contents[sq[0]][sq[1]]
  end

  def empty_sq?(sq)
    return_piece_at(sq).class == String
  end

  def outside_board?(sq)
    sq[0] < 0 || sq[0] > 7 || sq[1] > 8 || sq[1] < 1
  end

end

board = Board.new
pawn = Pawn.new(:white, [6,1])
puts board.target_within_moveset?([6,1],[5,1], pawn)
