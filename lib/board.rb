require_relative 'pieces'


# Board enforces the rules of chess and stores the current status of the game board.
class Board

  attr_reader :contents

  def initialize
    @contents =
              [['8',  Rook.new(:black, [0, 1]), Knight.new(:black, [0, 2]),
                Bishop.new(:black, [0, 3]),	Queen.new(:black, [0, 4]), King.new(:black, [0, 5]),
                Bishop.new(:black, [0, 6]),	Knight.new(:black, [0, 7]), Rook.new(:black, [0, 8])],
              ['7',  Pawn.new(:black, [1, 1], true), Pawn.new(:black, [1, 2], true),
               Pawn.new(:black,  [1, 3], true),	Pawn.new(:black, [1, 4], true), Pawn.new(:black, [1,5], true),
               Pawn.new(:black, [1,6], true),	Pawn.new(:black, [1,7], true), Pawn.new(:black, [1,8], true)],
               ['6',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['5',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['4',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['3',  ' ',' ',' ',' ',' ',' ',' ',' '],
               ['2',  Pawn.new(:white, [6 ,1], true), Pawn.new(:white, [6,2], true),
               Pawn.new(:white, [6,3], true), Pawn.new(:white, [6,4], true), Pawn.new(:white, [6,5], true),
               Pawn.new(:white, [6,6], true), Pawn.new(:white, [6,7], true), Pawn.new(:white, [6,8], true)],
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
    #puts "#{piece.first_move}"
  end

  def valid_move?(start, target, player_colour)
    return false if outside_board?(start) || outside_board?(target)
    return false if empty_sq?(start)
    return false if start == target
    piece = return_piece_at(start)
    return false if player_colour != piece.colour
    return false if !target_within_moveset?(target, piece.moveset) unless piece.class == Pawn
    return false if friendly_fire?(piece, target)
    if piece.class == Rook || piece.class == Bishop || piece.class == Queen
      return false if route_blocked?(start, target)
    end
    if piece.class == Pawn then return false if !valid_pawn_move?(piece, target) end
    true
  end

  def piece_under_attack?(location, defender_colour = return_piece_at(location).colour)
    attacker_colour = other_colour(defender_colour)
    #puts king_location
    @contents.each do |row|
      row.each do |piece|
        next if empty_sq?(piece) || piece.colour != attacker_colour
      #  puts "#{piece.moveset}" if piece.class == Queen
      #  moveset = piece.moveset
        return true if valid_move?(piece.location, location, attacker_colour)
      end
    end
    false
  end

  def checkmate?(king_colour)
    king_location = locate_piece(King, king_colour)
    #puts "King location: #{king_location}"
    attacker_locations = locate_attackers(king_location)
    #puts attackers.length
    #puts "Attackers: #{attackers}"
    return false if can_king_escape?(king_colour)
    # puts attackers.length
    # puts attackers.flatten.class
    if attacker_locations.length == 1
      attacker = return_piece_at(attacker_locations.flatten)
      #puts attacker
      return false if can_attackers_be_captured?(attacker_locations)
      if attacker.class == Rook || attacker.class == Bishop || attacker.class == Queen
        #puts "Attacker: #{attacker}"
        return false if can_attack_be_blocked?(attacker, king_colour)
      end
    end
    #puts "Can attackers be captured: #{can_attackers_be_captured?(attackers)}"
    true
  end

  #PRIVATE


# Careful that the method can deal w multiple attackers
  def can_attack_be_blocked?(attacker, king_colour)
    #return false if attackers.length > 1
    king_location = locate_piece(King, king_colour)
    route = intermediary_squares(attacker.location, king_location) << attacker.location
    #puts "#{route}"
    route.each do |square|
      if piece_under_attack?(square, king_colour) #&& locate_attackers(square)
         blocker_locations = locate_attackers(square, other_colour(king_colour))
         blocker_locations = remove_king(blocker_locations)
         return true if !blocker_locations.empty?
        #  #return false if blocker_locations.length > 1
        #  blocker = return_piece_at(blocker_locations.flatten)
        #  return true if blocker.class != King
       end
    end
    false
  end

  def remove_king(locations)
    locations.reject { |sq| return_piece_at(sq).class == King }
  end

  def can_attackers_be_captured?(attackers)
    return false if attackers.length > 1
    piece_under_attack?(attackers.flatten)
  end

  def can_king_escape?(king_colour)
    attacker_colour = other_colour(king_colour)
    king_location = locate_piece(King, king_colour)
    king = return_piece_at(king_location)
    #puts "#{king.location}"
    valid_moves = king.moveset.select {|move| valid_move?(king_location, move, king_colour)}
    #puts "valid moves: #{valid_moves}"
    out_of_check = valid_moves.select {|move| !piece_under_attack?(move, king_colour)}
    #puts "out of check: #{out_of_check}"
    out_of_check.length > 0
  end

  def locate_attackers(location, defender_colour = return_piece_at(location).colour)
    attacker_colour = other_colour(defender_colour)
    attackers = []
    @contents.each do |row|
      row.each do |piece|
        next if empty_sq?(piece) || piece.colour != attacker_colour
        attackers << piece.location if valid_move?(piece.location, location, attacker_colour)
      end
    end
    attackers
  end

  # def check?(king_location, king_colour, player_colour)
  #   #king_location = locate_piece(King, king_colour)
  #   #puts king_location
  #   @contents.each do |row|
  #     row.each do |piece|
  #       next if piece.class == String || piece.colour == king_colour
  #     #  puts "#{piece.moveset}" if piece.class == Queen
  #       moveset = piece.moveset
  #       return true if valid_move?(piece.location, king_location, player_colour)
  #     end
  #   end
  #   false
  # end


  def valid_pawn_move?(piece, target)
    target_type = target_type(target)
    moveset = piece.moveset(target_type)
    return false if double_pawn_move?(piece, target) && transition_square_blocked?(piece)
    target_within_moveset?(target, moveset)
  end

  def double_pawn_move?(piece, target)
    x_start, y_start = piece.location[0], piece.location[1]
    x_target, y_target = target[0], target[1]
    x_start == x_target + 2 || x_start == x_target - 2 && y_start == y_target
  end

  def transition_square_blocked?(piece)
    x,y = piece.location[0], piece.location[1]
    if piece.colour == :white
      !empty_sq?([x-1,y])
    else
      !empty_sq?([x+1,y])
    end
  end

  def target_type(location)
    empty_sq?(location) ? :empty : :enemy
  end

  def other_colour(colour)
    (colour == :white) ? :black : :white
  end

  def locate_piece(class_to_find, colour)
    locations = []
    @contents.each do |row|
      row.each do |piece|
        locations << piece.location if piece.class == class_to_find && piece.colour == colour
      end
    end
    locations = locations.flatten if locations.length == 1
    locations
  end

  def route_blocked?(start, target)
    route = intermediary_squares(start, target)
    #puts "ROUTE: #{route}"
    route.any? {|square| return_piece_at(square) != ' '}
  end

  def intermediary_squares(start, target)
    moveset = return_piece_at(start).moveset
    line = moveset.select {|a| a.include?(target)}.flatten(1)
    start_index, target_index = line.index(start), line.index(target)
    #  puts "START #{start_index}"
    #  puts "TARGET #{target_index}"
    #  puts "LINE: #{line}"
    if start_index > target_index
      line = line.reverse
      start_index, target_index = line.index(start), line.index(target)
    end
    # puts "START #{start_index}"
    # puts "TARGET #{target_index}"
    # puts "LINE: #{line}"
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
    square = (sq.class == Array) ? return_piece_at(sq) : sq
    square.class == String
  end

  def outside_board?(sq)
    sq[0] < 0 || sq[0] > 7 || sq[1] > 8 || sq[1] < 1
  end

end

#
#   board = Board.new
#   pawn = board.return_piece_at([1,1])

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
