require_relative 'board'
require_relative 'player'



class Game

  # def initialize
  #
  # end


def start_game
  @board = Board.new
  @contents = @board.contents
  @board.visualise
  create_players

  #puts @contents[1][1].icon
  #@board.move([6,1],[5,1])
  #puts @board.return_piece_at([6,1]).class
  #puts @board.return_piece_at([5,1]).class
  #puts @board.target_within_moveset?([6,1],[5,1])
  
end

  def switch_current_player
    @current_player = (@current_player == @players[0] ? @players[1] : @players[0])
  end

  def create_players
    @players = []
    @players << Player.new(1, :white)
    @players << Player.new(2, :black)
    @current_player = @players[0]
  end





end

Game.new.start_game
