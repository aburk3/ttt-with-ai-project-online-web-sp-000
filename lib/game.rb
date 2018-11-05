require 'pry'


class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  def current_player
    @board.turn_count % 2 == 0 ? player_1 : player_2
  end

  def won?
    WIN_COMBINATIONS.detect do |combination|
      @board.cells[combination[0]] == @board.cells[combination[1]] &&
      @board.cells[combination[1]] == @board.cells[combination[2]] &&
      @board.taken?(combination[0] + 1)
    end
  end

  def draw?
    !won? && @board.full?
  end

  def over?
    draw? || won?
  end

  def winner
    if winning_combo = won?
      @winner = @board.cells[winning_combo.first]
    end
  end

  def turn
    player = current_player
    current_move = player.move(@board)
    if !@board.valid_move?(current_move)
      turn
    else
      puts "Turn: #{@board.turn_count + 1}"
      @board.display
      @board.update(current_move, player)
      puts "#{player.token} moved #{current_move}"
      @board.display
      puts "\n"
    end
  end

  def play
    while !over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
      @board.display
    elsif draw?
      puts "Cat's Game!"
      @board.display
      # binding.pry
    end
    puts "Would you like to play again? (y/n)"
    input = gets.chomp
    if input == "y"
      Game.start
    end
  end


  def self.start
    puts "Would you like to play 0, 1, or 2 player mode?"
      input = gets.strip
      player_1 = nil
      player_2 = nil

    if input == "0"
      player_1 = Players::Computer.new("O")
      player_2 = Players::Computer.new("X")
      Game.new(player_1, player_2).play


    elsif input == "1"
      puts "Great! Would you like to go 'first' and be X or 'second' and be O?"
      input_player = gets.strip
      if input_player == "first"
        player_1 = Players::Human.new("X")
        player_2 = Players::Computer.new("O")
      else
        player_1 = Players::Computer.new("X")
        player_2 = Players::Human.new("O")
      end
      Game.new(player_1, player_2).play

    elsif input == "2"
      puts "Okay, two player mode it is!"
      puts "Great! Would you like to go 'first' and be X or 'second' and be O?"
      input_player = gets.strip
      if input_player == "first"
        player_1 = Players::Human.new("X")
        player_2 = Players::Human.new("O")
      else
        player_1 = Players::Human.new("X")
        player_2 = Players::Human.new("O")
      end
      Game.new(player_1, player_2).play
    end
  end
end
