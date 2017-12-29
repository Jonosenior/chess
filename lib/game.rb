require_relative 'board'
require_relative 'player'



class Game

  def start_game
    @board = Board.new
    @contents = @board.contents
    @board.visualise
    create_players
    set_current_player
  end


  def create_players
    @players = [Player.new(1, :white)] << Player.new(2, :black)
  end


  def set_current_player
    @current_player = @players[0]
  end


  def switch_current_player
    @current_player = (@current_player == @players[0] ? @players[1] : @players[0])
  end

end

Game.new.start_game
