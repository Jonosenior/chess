require_relative 'board'
require_relative 'pieces'


class Game

  @board = Board.new
  @contents = @board.contents
  @board.visualise
  #puts @contents[1][1].icon
  @board.move([6,1],[5,1])

end
