class Player

  attr_reader :colour, :name

  def initialize(number, colour)
    @colour = colour
    @name = elicit_name(number)
  end

  def elicit_name(number)
    puts "\n\nWhat's your name, Player #{number}?"
    gets.chomp
  end

  def elicit_move
    puts "\n\n#{@name.upcase}"
    puts "Enter move (for example 'b1 to c3'):"
    moves = convert_to_move(gets.chomp)
    while !moves
      puts "That square doesn't exist!"
      puts "\nEnter move (for example 'b1 to c3'):"
      moves = convert_to_move(gets.chomp)
    end
    moves
  end

  def convert_to_move(input)
    moves = alphanumeric_pairs(input)
    moves = moves.map { |move| convert(move) }
    valid_output?(moves) ? moves : false
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
    columns = {"A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5, "F" => 6, "G" => 7, "H" => 8}
    columns[letter.upcase]
  end

  def convert_row(number)
    rows = {8 => 0, 7 => 1, 6 => 2, 5 => 3, 4 => 4, 3 => 5, 2 => 6, 1 => 7}
    rows[number]
  end

  def valid_output?(moves)
    moves.length == 2 && moves.each {|move| move.length == 2 && move.each {|row_or_col| (0..8).include?(row_or_col)}}
  end

  def elicit_pawn_promotion
    puts "\n\nPAWN PROMOTION!"
    puts "#{@name.capitalize}, your pawn made it to the last row."
    puts "Which piece would you like to promote him to?"
    puts "Choose: Queen, Rook, Bishop or Knight."
    new_class = gets.chomp.capitalize
    while !valid_pawn_promotion_input?(new_class)
      puts "Invalid choice!"
      puts "Please type Queen, Rook, Bishop or Knight."
      new_class = gets.chomp.capitalize
    end
    new_class
  end

  def valid_pawn_promotion_input?(input)
    possible_classes = ["Queen","Rook","Bishop","Knight"]
    possible_classes.include?(input)
  end

end
