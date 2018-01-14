require_relative 'board'
require_relative 'player'
require 'pry'



class Game

  def new_game
    @board = Board.new
    @contents = @board.contents
    @board.visualise
    create_players
    set_current_player
  end

  def new_turn
    loop do
      #binding.pry
      moves = @current_player.elicit_move
      start = moves[0]
      target = moves[1]
      #binding.pry
      if !@board.valid_move?(start, target, @current_player.colour)
        puts "Not a valid move!"
        redo
      end
      process_turn(start, target)
      @board.visualise
      review_game_status
      complete_turn
    end
  end

  def review_game_status
    status = @board.game_status(@current_player.colour)
    case status
    when :checkmate
      puts "checkmate!"
      puts "Congratulations #{@current_player.name}! You won."
      exit
    when :stalemate
      puts "Stalemate!"
      exit
    when :check
      puts "Check!"
    end
  end

  def process_turn(start, target)
    #binding.pry
    @board.en_passant(@current_player.colour, start, target)
    #binding.pry
    @board.move(start, target)
    #binding.pry
    pawn_promotion
  end

  def complete_turn
    switch_current_player
  end

  def pawn_promotion
    if @board.pawn_to_promote?(@current_player.colour)
      new_class_string = @current_player.elicit_pawn_promotion
      new_class = class_string_to_class_name(new_class_string)
      @board.promote(new_class, @current_player.colour)
    end
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

  def class_string_to_class_name(class_name_string)
    Object.const_get(class_name_string)
  end


end

game = Game.new
game.new_game
game.new_turn
#            "A"  "B"     "C"    "D"    "E"     "F"   "G"     "H"
# [  8  , "0,1", "0,2", "0,3", "0,4", "0,5", "0,6", "0,7", "0,8"]
#
# [  7  , "1,1", "1,2", "1,3", "1,4", "1,5", "1,6", "1,7", "1,8"]
#
# [  6  , "2,1", "2,2", "2,3", "2,4", "2,5", "2,6", "2,7", "2,8"]
#
# [  5  , "3,1", "3,2", "3,3", "3,4", "3,5", "3,6", "3,7", "3,8"]
#
# [  4  , "4,1", "4,2", "4,3", "4,4", "4,5", "4,6", "4,7", "4,8"]
#
# [  3  , "5,1", "5,2", "5,3", "5,4", "5,5", "5,6", "5,7", "5,8"]
#
# [  2  , "6,1", "6,2", "6,3", "6,4", "6,5", "6,6", "6,7", "6,8"]
#
# [  1  , "7,1", "7,2", "7,3", "7,4", "7,5", "7,6", "7,7", "7,8"]
