class Player

  attr_reader :colour, :name

  def initialize(number, colour)
    @colour = colour
    @name = elicit_name(number)
  end

  def elicit_name(number)
    puts "What's your name, Player #{number}?"
    gets.chomp
  end

  def elicit_move
    puts "Make your turn"
    puts "Row first (0 - 7), then column (1-8)"
    puts "For example '08 to 64'"
    convert_to_move(gets.chomp)
  end

  def convert_to_move(input)
    input.scan(/\d+/).map { |b| b.to_s.chars.map(&:to_i) }
  end

end
