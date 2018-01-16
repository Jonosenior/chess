require_relative 'board'
require_relative 'player'
require_relative 'text'

class Game

  def new_game
    @board = Board.new
    @contents = @board.contents
    @text = Text.new
    @text.title
    @board.visualise
    create_players
    set_current_player
  end

  def new_turn
    loop do
      moves = @current_player.elicit_move
      start = moves[0]
      target = moves[1]
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
      puts "Checkmate!\n"
      puts "Congratulations #{@current_player.name}! You won."
      exit
    when :stalemate
      puts "Stalemate!\n"
      puts "Everyone's a loser..."
      exit
    when :check
      puts "Check!"
    end
  end

  def process_turn(start, target)
    @board.en_passant(@current_player.colour, start, target)
    @board.move(start, target)
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
