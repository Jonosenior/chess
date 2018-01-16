require_relative 'pieces'


# Board enforces the rules of chess and stores the current status of the game board.
class Board

  attr_reader :contents

  def initialize
    @contents =
              [['8',  Rook.new(:black, [0, 1], true), Knight.new(:black, [0, 2]),
                Bishop.new(:black, [0, 3]),	Queen.new(:black, [0, 4]), King.new(:black, [0, 5], true),
                Bishop.new(:black, [0, 6]),	Knight.new(:black, [0, 7]), Rook.new(:black, [0, 8], true)],
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
                ['1',  Rook.new(:white, [7,1], true), Knight.new(:white, [7,2]),
                Bishop.new(:white, [7,3]), Queen.new(:white, [7,4]), King.new(:white, [7,5], true),
                Bishop.new(:white, [7,6]), Knight.new(:white, [7,7]), Rook.new(:white, [7,8], true)]]
  end


  public

  def visualise
    puts "\n"
    puts [' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map {|square| square.center(3)}.join(" ") + "\n\n"
		@contents.map do |line|
			puts line.map { |square| square =~ /\w|\s/ ? square.center(3) : square.icon.center(3) }.join(" ")
      puts "\n"
		end
	end


  def game_status(player_colour)
    defender_colour = other_colour(player_colour)
    king_location = locate_piece(King, defender_colour)
    if piece_under_attack?(king_location, defender_colour)
      checkmate?(defender_colour) ? :checkmate : :check
    elsif stalemate?(player_colour)
       :stalemate
    else
      :next_move
    end
  end

  def en_passant(player_colour, start, target)
    set_en_passant_square(player_colour, target) if en_passant_possible?(start, target)
    reset_en_passant_square(player_colour)
  end

  def en_passant_possible?(start, target)
    piece = return_piece_at(start)
    piece.class == Pawn && double_sq_pawn_move?(start, target)
  end

  def move(start, target)
    if castling_move?(start, target) then move_castling_rook(start, target) end
    if en_passant_attack?(start, target) then delete_en_passant(start, target) end
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
    if piece.class == Pawn then return false if !valid_pawn_move?(piece, target) end
    return false if own_king_in_check?(start, target) unless castling_move?(start, target)
    if castling_move?(start, target) then return false if !valid_castling_move?(piece, target) end
    true
  end

  def valid_castling_move?(piece, target)
    rook = return_castling_rook(piece.location, target)
    return false if rook.class != Rook || !rook.first_move
    return false if route_blocked?(rook.location, piece.location)
    return false if piece_under_attack?(piece.location, piece.colour)
    route = intermediary_squares(rook.location, piece.location)
    return false if route_in_check?(route, piece.colour)
    true
  end

  def piece_under_attack?(location, defender_colour = return_piece_at(location).colour)
    attacker_colour = other_colour(defender_colour)
    @contents.each do |row|
      row.each do |piece|
        next if empty_sq?(piece) || piece.colour != attacker_colour
        return true if valid_move?(piece.location, location, attacker_colour)
      end
    end
    false
  end

  def move_castling_rook(king_start, king_target)
    rook = return_castling_rook(king_start, king_target)
    kingside = (king_target[1] == king_start[1] + 2) ? true : false
    rook_target = (kingside) ? [king_start[0], king_start[1] + 1] : [king_start[0], king_start[1] - 1]
    move(rook.location, rook_target)
  end

  def own_king_in_check?(start, target)
    piece = return_piece_at(start)
    target_piece = return_piece_at(target)
    move(start, target)
    king_location = locate_piece(King, piece.colour)
    own_king_threatened = piece_under_attack?(king_location)
    undo_move(start, target, piece, target_piece)
    own_king_threatened
  end

  def undo_move(start_location, target_location, start_piece, target_piece)
    delete_at(target_location)
    create_new_piece_at(start_piece, start_location)
    create_new_piece_at(target_piece, target_location)
  end

  def stalemate?(player_colour)
    king_colour = other_colour(player_colour)
    king_location = locate_piece(King, king_colour)
    !piece_under_attack?(king_location, king_colour) && !any_valid_moves?(king_colour)
  end

  def any_valid_moves?(king_colour)
    @contents.each do |row|
      row.each do |piece|
        next if empty_sq?(piece) || piece.colour != king_colour
        piece.moveset.each do |target|
          if target[0].class == Array
            target.each do |target_sub|
              return true if valid_move?(piece.location,target_sub,king_colour)
            end
          else
            return true if valid_move?(piece.location,target,king_colour)
          end
        end
      end
    end
    false
  end

  def checkmate?(king_colour)
    king_location = locate_piece(King, king_colour)
    attacker_locations = locate_attackers(king_location)
    return false if can_king_escape?(king_colour)
    if attacker_locations.length == 1
      attacker = return_piece_at(attacker_locations.flatten)
      return false if can_attackers_be_captured?(attacker_locations)
      if attacker.class == Rook || attacker.class == Bishop || attacker.class == Queen
        return false if can_attack_be_blocked?(attacker, king_colour)
      end
    end
    true
  end

  def pawn_to_promote?(player_colour)
    row = (player_colour == :white) ? 0 : 7
    @contents[row].any? {|a| a.class == Pawn}
  end

  def promote(new_class, colour)
    pawn_index = index_of_pawn_to_promote(colour)
    new_piece = new_class.new(colour,pawn_index)
    create_new_piece_at(new_piece,pawn_index)
  end

  def index_of_pawn_to_promote(player_colour)
    row = (player_colour == :white) ? 0 : 7
    col = @contents[row].index {|a| a.class == Pawn}
    [row,col]
  end

  def en_passant_attack?(start, target)
    piece = return_piece_at(start)
    player_colour = piece.colour
    piece.class == Pawn && target == return_en_passant_square(player_colour)
  end

  def set_en_passant_square(pawn_colour,target)
    if pawn_colour == :white
      @en_passant_white = passed_square(:white,target)
    else
      @en_passant_black = passed_square(:black,target)
    end
  end

  def delete_en_passant(start, target)
    player_colour = return_piece_at(start).colour
    passed_pawn = player_colour == :white ? [target[0] + 1, target[1]] : [target[0] - 1, target[1]]
    delete_at(passed_pawn)
  end

  def return_en_passant_square(player_colour)
    pawn_colour = other_colour(player_colour)
    pawn_colour == :white ? @en_passant_white : @en_passant_black
  end

  def passed_square(pawn_colour, target)
    y = target[0]
    x = target[1]
    pawn_colour == :white ? [y+1,x] : [y-1,x]
  end

  def reset_en_passant_square(player_colour)
    colour = other_colour(player_colour)
    colour == :white ? @en_passant_white = [] : @en_passant_black = []
  end


  #PRIVATE


  def can_attack_be_blocked?(attacker, king_colour)
    king_location = locate_piece(King, king_colour)
    route = intermediary_squares(attacker.location, king_location) << attacker.location
    route.each do |square|
      if piece_under_attack?(square, king_colour)
         blocker_locations = locate_attackers(square, other_colour(king_colour))
         blocker_locations = remove_king(blocker_locations)
         return true if !blocker_locations.empty?
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
    valid_moves = king.moveset.select {|move| valid_move?(king_location, move, king_colour)}
    out_of_check = valid_moves.select {|move| !piece_under_attack?(move, king_colour)}
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

  def valid_pawn_move?(piece, target)
    y_start, x_start = piece.location[0], piece.location[1]
    y_target, x_target = target[0], target[1]
    return true if target == return_en_passant_square(piece.colour)
    return false if diagonal_pawn_move?(y_start, x_start, y_target, x_target) && empty_sq?(target)
    return false if !diagonal_pawn_move?(y_start, x_start, y_target, x_target) && !empty_sq?(target)
    return false if double_sq_pawn_move?(piece.location, target) && transition_square_blocked?(y_start, x_start, piece.colour)
    true
  end

  def diagonal_pawn_move?(y_start, x_start, y_target, x_target)
    y_start != y_target && x_start != x_target
  end

  def double_sq_pawn_move?(start, target)
    y_start, x_start = start[0], start[1]
    y_target, x_target = target[0], target[1]
    y_start == y_target + 2 || y_start == y_target - 2 && x_start == x_target
  end

  def transition_square_blocked?(y_start, x_start, piece_colour)
    piece_colour == :white ? !empty_sq?([y_start-1,x_start]) : !empty_sq?([y_start+1,x_start])
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
    route.any? {|square| return_piece_at(square) != ' '}
  end

  def intermediary_squares(start, target)
    moveset = return_piece_at(start).moveset
    line = moveset.select {|a| a.include?(target)}.flatten(1)
    start_index, target_index = line.index(start), line.index(target)
    if start_index > target_index
      line = line.reverse
      start_index, target_index = line.index(start), line.index(target)
    end
    route = line[start_index+1...target_index]
  end

  def delete_at(sq)
    @contents[sq[0]][sq[1]] = ' '
  end

  def create_new_piece_at(piece, square)
    if empty_sq?(piece)
      @contents[square[0]][square[1]] = ' '
    else
      @contents[square[0]][square[1]] = (piece.class).new(piece.colour, square)
    end
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

  def return_castling_rook(start, target)
    kingside = (target[1] == start[1] + 2) ? true : false
    rook_location = kingside ? [target[0], target[1] + 1] : [target[0], target[1] - 2]
    return_piece_at(rook_location)
  end

  def route_in_check?(route, king_colour)
    route.each do |square|
      return true if piece_under_attack?(square, king_colour)
    end
    false
  end

  def castling_move?(start, target)
    y_start, x_start = start[0], start[1]
    y_target, x_target = target[0], target[1]
    piece = return_piece_at(start)
    return false if piece.class != King
    y_start == y_target && (x_target == x_start + 2 || x_target == x_start - 2)
  end

end
