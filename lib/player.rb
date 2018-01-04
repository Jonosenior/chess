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
    moves = alphanumeric_pairs(input)
    moves.map { |move| convert(move) }
  end

  def convert(input)
    row = convert_row(input[1].to_i)
    column = convert_column(input[0])
    [row, column]
  end

  def alphanumeric_pairs(input)
    input.scan(/[a-hA-H][1-8]/)
  end

  def convert_column(letter)
    columns = {"A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5, "F" => 6, "H" => 8}
    columns[letter.upcase]
  end

  def convert_row(number)
    rows = {8 => 0, 7 => 1, 6 => 2, 5 => 3, 4 => 4, 3 => 5, 2 => 6, 1 => 7}
    rows[number]
  end

end
