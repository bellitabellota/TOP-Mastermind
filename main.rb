require "colorize"

class Game
  attr_reader :players, :colors
  attr_accessor :secret_code, :all_guesses, :turn

  def initialize(player1, player2)
    @colors = ["yellow", "blue", "magenta", "red", "green", "cyan"]
    @secret_code = Array.new(4)
    @turn = 0
    @players = [player1.new(self, 1), player2.new(self, 2)] # self here is referencing the game object
    @all_guesses = Array.new(12) { Array.new(4, " ") }
  end

  def play
    self.secret_code = players[1].choose_random_secret_code
    visualize_board

    self.all_guesses[turn] = players[0].make_guess
    self.turn += 1
    visualize_board
  end

  def visualize_board
    line_number = 12

    while line_number > 0
      if self.all_guesses[line_number - 1].all? { |color| color != " " }
        display_guess(line_number)
      else
        puts "    |   ||   |   |   |   ||   |   Turn #{line_number}"
      end
      line_number -= 1
    end
    puts "           1   2   3   4 "
  end

  def display_guess(line_number)
    puts "    |   || #{' '.colorize(background: self.all_guesses[0][0].to_sym)} | #{
      ' '.colorize(background: self.all_guesses[0][1].to_sym)} | #{
      ' '.colorize(background: self.all_guesses[0][2].to_sym)} | #{
      ' '.colorize(background: self.all_guesses[0][3].to_sym)} ||   |   Turn #{line_number}"
  end

  def display_colors_of_pins
    puts "The pin colors are: #{
      self.colors[0]}, #{
      self.colors[1]}, #{
      self.colors[2]}, #{
      self.colors[3]}, #{
      self.colors[4]} and #{
      self.colors[5]}."
  end
end

class Player
  attr_reader :game

  def initialize(game, player_id)
    @game = game
    @player_id = player_id
  end
end

class HumanPlayer < Player
  def make_guess
    game.display_colors_of_pins
    guess = Array.new(4)
    get_and_validate(guess)
    guess
  end

  def get_and_validate(guess)
    index = 0
    while index < 4
      loop do
        puts "Please enter your guess for Position #{index + 1}:"
        guess[index] = gets.chomp
        break guess[index] if game.colors.include?(guess[index])

        puts "Invalid choice. Please try again."
      end
      index += 1
    end
  end
end

class ComputerPlayer < Player
  def choose_random_secret_code
    game.secret_code.map { |position| position = game.colors.sample }
  end
end

game = Game.new(HumanPlayer, ComputerPlayer)
game.play
puts "secret code: #{game.secret_code}"
