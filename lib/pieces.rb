class Piece
  attr_reader :colour, :location

  def initialize(colour, location)
    @colour = colour
    @location = location
  end

end

class Pawn < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265F" : @icon = "\u2659"
  end

  def moveset
    @colour == :white ? [@location[0]-1, @location[1]] : [@location[0]+1, @location[1]]
  end

end

class Knight < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265E" : @icon = "\u2658"
  end

  def moveset
  end

end


class Rook < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265C" : @icon = "\u2656"
  end

  def moveset
    column + row
  end

  def column
    (0..7).map { |i| [i,location[1]] }
  end

  def row
    (0..7).map { |i| [location[0],i] }
  end

end

class Bishop < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265D" : @icon = "\u2657"
  end

  def moveset
  end

end


class Queen < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265B" : @icon = "\u2655"
  end

  def moveset
  end

end

class King < Piece
  attr_reader :icon

  def initialize(colour, location)
    super
    @colour == :white ? @icon = "\u265A" : @icon = "\u2654"
  end

  def moveset
  end

end





# pawn = Pawn.new(:white, [3,3])
# puts pawn.icon.encode('utf-8')


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
#
