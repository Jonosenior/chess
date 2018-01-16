class Piece
  attr_reader :colour, :location

  def initialize(colour, location)
    @colour = colour
    @location = location
  end

  def board_limits(x,y)
    x < 0 || x > 7 || y < 1 || y > 8
  end

end

class Pawn < Piece
  attr_reader :icon, :first_move

  def initialize(colour, location, first_move = false)
    super(colour, location)
    @colour == :white ? @icon = "\u265F" : @icon = "\u2659"
    @first_move = first_move
  end

  def moveset
    y = @location[0]
    x = @location[1]

    @colour == :white ? moveset = moveset_white(y,x) : moveset = moveset_black(y,x)
    moveset.delete_if { |a| board_limits(a[0],a[1]) }
  end

  def moveset_white(y,x)
    @first_move ? [[y-1, x],[y-2,x],[y-1, x+1],[y-1, x-1]] : [[y-1,x],[y-1, x+1], [y-1, x-1]]
  end

  def moveset_black(y,x)
    @first_move ? [[y+1, x],[y+2,x],[y+1, x+1],[y+1, x-1]] : [[y+1,x],[y+1, x+1],[y+1, x-1]]
  end

end


class Knight < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265E" : @icon = "\u2658"
  end

  def moveset
    possible_moves = []
    possible_rows.each do |row|
      possible_columns.each do |col|
        possible_moves << [row,col] if legal_knight_move?(location, [row,col])
      end
    end
    possible_moves.delete_if { |a| board_limits(a[0],a[1]) }
  end

  def legal_knight_move?(start_position,finish_position)
    (start_position[0] - finish_position[0]).abs + (start_position[1] - finish_position[1]).abs == 3
  end

  def possible_rows
    [location[0]+2,location[0]+1,location[0]-1,location[0]-2]
  end

  def possible_columns
     [location[1]+2,location[1]+1,location[1]-1,location[1]-2]
  end


end


class Rook < Piece
  attr_reader :icon, :first_move

  def initialize(colour, location, first_move = false)
    super(colour, location)
    @colour == :white ? @icon = "\u265C" : @icon = "\u2656"
    @first_move = first_move
  end

  def moveset
    [column] + [row]
  end

  def column
    (0..7).map { |i| [i,location[1]] }
  end

  def row
    (1..8).map { |i| [location[0],i] }
  end

end

class Bishop < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265D" : @icon = "\u2657"
  end

  def moveset
    x = location[0]
    y = location[1]

    [top_right_diagonal(x,y)] + [top_left_diagonal(x,y)] + [bottom_left_diagonal(x,y)] + [bottom_right_diagonal(x,y)]
  end

  def top_right_diagonal(x,y)
    tr_diagonal = []
    until board_limits(x,y)
      tr_diagonal << [x,y]
      x -= 1
      y += 1
    end
    tr_diagonal
  end

  def top_left_diagonal(x,y)
    tl_diagonal = []
    until board_limits(x,y)
      tl_diagonal << [x,y]
      x -= 1
      y -= 1
    end
    tl_diagonal
  end

  def bottom_left_diagonal(x,y)
    bl_diagonal = []
    until board_limits(x,y)
      bl_diagonal << [x,y]
      x += 1
      y -= 1
    end
    bl_diagonal
  end

  def bottom_right_diagonal(x,y)
    br_diagonal = []
    until board_limits(x,y)
      br_diagonal << [x,y]
      x += 1
      y += 1
    end
    br_diagonal
  end

end


class Queen < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265B" : @icon = "\u2655"
    @rook = Rook.new(colour, location)
    @bishop = Bishop.new(colour, location)
  end

  def moveset
    @rook.moveset + @bishop.moveset
  end

end

class King < Piece
  attr_reader :icon, :first_move

  def initialize(colour, location, first_move = false)
    super(colour, location)
    @colour == :white ? @icon = "\u265A" : @icon = "\u2654"
    @first_move = first_move
  end

  def moveset
    x = location[0]
    y = location[1]

    moveset = [[x-1,y],[x-1,y-1],[x,y-1],[x+1,y-1],[x+1,y],[x+1,y+1],[x,y+1],[x-1,y+1]]
    moveset << [x,y-2] << [x,y+2] if @first_move
    moveset.delete_if { |a| board_limits(a[0],a[1]) }
  end

end
