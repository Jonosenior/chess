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

end
