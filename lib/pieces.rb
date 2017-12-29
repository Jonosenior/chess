class Piece
  attr_reader :colour
  attr_accessor :location

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
 # "\u{2658}"

end

#
# pawn = Pawn.new(:white, [3,3])
# puts pawn.icon.encode('utf-8')
