require_relative 'pieces'

class Board

  attr_reader :contents

  def initialize
    @contents =
              [['8',  Rook.new(:black, [0,1]), Knight.new(:black, [0,2]),
                Bishop.new(:black, [0,3]),	Queen.new(:black, [0,4]), King.new(:black, [0,5]),
                Bishop.new(:black, [0,6]),	Knight.new(:black, [0,7]), Rook.new(:black, [0,8])],
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
                ['1',  Rook.new(:white, [7,1]), Knight.new(:white, [7,2]),
                Bishop.new(:white, [7,3]), Queen.new(:white, [7,4]), King.new(:white, [7,5]),
                Bishop.new(:white, [7,6]), Knight.new(:white, [7,7]), Rook.new(:white, [7,8])]]
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

  def valid_move?(start, target, player_colour)
    return false if outside_board?(start) || outside_board?(target)
    return false if empty_sq?(start)
    return false if start == target
    piece = return_piece_at(start)
    return false if player_colour != piece.colour
    return false if !target_within_moveset?(target, piece.moveset)
    return false if friendly_fire?(piece, target)
    if piece.class == Rook || piece.class == Bishop || piece.class == Queen
      return false if route_blocked?(start, target)
    end
    true
  end

  def checkmate?(king_colour, player_colour)
    return false if can_king_escape?(king_colour, player_colour)
    true
  end

  def can_king_escape?(king_colour, player_colour)
    king_location = locate_king(king_colour)
    king = return_piece_at(king_location)
    puts king.location
    valid_moves = king.moveset.select {|move| valid_move?(king_location, move, king_colour)}
    puts "#{valid_moves}"
    out_of_check = valid_moves.select {|move| !check?(move, king_colour, player_colour)}
    puts "#{out_of_check}"
    !out_of_check.empty?
  end

  def check?(king_location, king_colour, player_colour)
    #king_location = locate_king(king_colour)
    #puts king_location
    @contents.each do |row|
      row.each do |piece|
        next if piece.class == String
        puts "#{piece.moveset}" if piece.class == Queen
        moveset = piece.moveset
        return true if target_within_moveset?(king_location, moveset) && valid_move?(piece.location, king_location, player_colour)
      end
    end
    false
  end

  #private

  def locate_king(king_colour)
    @contents.each_with_index do |row, i|
      @contents.each_with_index do |row, j|
        piece = return_piece_at([i,j])
        return [i,j] if piece.class == King && piece.colour == king_colour
      end
    end
  end

  def route_blocked?(start, target)
    route = intermediary_squares(start, target)
    #puts "ROUTE: #{route}"
    route.any? {|square| return_piece_at(square) != ' '}
  end

  def intermediary_squares(start, target)
    #moveset = [[[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]], [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8]]]
    moveset = return_piece_at(start).moveset
    line = moveset.select {|a| a.include?(target)}.flatten(1)
    start_index, target_index = line.index(start), line.index(target)
    # puts "START #{start_index}"
    # puts "TARGET #{target_index}"
    # puts "#{line}"
    if start_index > target_index
      line = line.reverse
      start_index, target_index = target_index, start_index
    end
    #puts "#{line}"
    #puts "LINE: #{line[start_index...target_index]}"
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
    !empty_sq?(target) && piece.colour == return_piece_at(target).colour
  end

  def target_within_moveset?(target, moveset)
    moveset == target || moveset.include?(target) || moveset.flatten(1).include?(target)
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

# board = Board.new
# board.check?
#board.contents.each { |a| a.each { |b| puts b.class}}
#board.check?([0,4],:black,:white)
#board.contents.each { |a| a.each {|b| puts b.class}}
 # king_location = board.locate_king(:white)
 # puts board.check?(king_location, :black)
# board.contents.each do |piece|
#   puts piece.location# if piece.class == King && piece.colour == player_colour
# end

# puts "#{board.return_piece_at([0,2]).moveset}"

# start = [0,2]
# target = [2,3]
# piece = board.return_piece_at(start)
# puts "#{piece.moveset}"

# puts "#{piece.moveset.flatten(2)}"
# puts "#{board.valid_move?(start, target, :black)}"
#puts "#{board.}"
 # puts "#{board.return_piece_at([0,2]).moveset}"
# pawn = Pawn.new(:white, [6,1])
# puts "PAWN"
# start = [6,1]
# target = [5,1]
# puts board.target_within_moveset?([6,1],[5,1], pawn)
# puts board.valid_move?([6,1],[5,1], :white)
# puts false if board.outside_board?(start) || board.outside_board?(target)
# puts false if board.empty_sq?(start)
# puts false if start == target
# piece = board.return_piece_at(start)
# return false if player_colour != piece.colour
# return false if !target_within_moveset?(start, target, piece)
# return false if friendly_fire?(piece, target)
# return false if route_blocked?(start, target)
#



#  rook = Rook.new(:black, [2,1])
#  puts "#{rook.moveset}"
# # board.visualise
# board.delete_at([6,1])
# board.visualise
# #puts board.target_within_moveset?([2,1],[2,8], rook)
# puts board.valid_move?([7,1], [0,1], :white)
# puts board.route_blocked?([7,1], [0,1])


#[[[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]], [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8]]]


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
