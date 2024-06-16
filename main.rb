require "colorize"

class Game
  attr_reader :players, :colors
  attr_accessor :secret_code, :all_guesses, :turn, :evaluated_guesses

  def initialize(player1, player2)
    @colors = ["yellow", "blue", "magenta", "red", "green", "cyan"]
    @secret_code = Array.new(4)
    @turn = 0
    @players = [player1.new(self, 1), player2.new(self, 2)] # self here is referencing the game object
    @all_guesses = Array.new(12) { Array.new(4, " ") }
    @evaluated_guesses = Array.new(12) { Array.new(4, " ") }
  end

  def play
    self.secret_code = players[1].choose_random_secret_code
    visualize_board

    self.all_guesses[turn] = players[0].make_guess
    # puts "secret code:"
    # p self.secret_code
    evaluate_guess

    visualize_board
    self.turn += 1
  end

  def evaluate_guess
    self.secret_code.each_with_index do |secret_color, secret_position|
      all_guesses[self.turn].each_with_index do |color_guessed, guessed_position|
        if color_guessed == secret_color && guessed_position == secret_position
          self.evaluated_guesses[self.turn][guessed_position] = "+"
          next
        elsif color_guessed == secret_color && !guessed_position == secret_position
          self.evaluated_guesses[self.turn][guessed_position] = "~"
        end
      end
    end
  end


  def visualize_board
    line_number = 12

    while line_number > 0
      if self.all_guesses[line_number - 1].all? { |color| color != " " }
        display_guess_and_evaluation(line_number)
      else
        puts "    |   ||   |   |   |   ||   |   Turn #{line_number}"
      end
      line_number -= 1
    end
    puts "           1   2   3   4 "
  end

  def display_guess_and_evaluation(line_number)
    puts "  #{self.evaluated_guesses[turn][0]} | #{
      self.evaluated_guesses[turn][1]} || #{
      ' '.colorize(background: self.all_guesses[turn][0].to_sym)} | #{
      ' '.colorize(background: self.all_guesses[turn][1].to_sym)} | #{
      ' '.colorize(background: self.all_guesses[turn][2].to_sym)} | #{
      ' '.colorize(background: self.all_guesses[turn][3].to_sym)} || #{
      self.evaluated_guesses[turn][2]} | #{
      self.evaluated_guesses[turn][3]} Turn #{line_number}"
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
    p game.secret_code.map { |position| position = game.colors.sample }

  end
end

game = Game.new(HumanPlayer, ComputerPlayer)
game.play
# print game.secret_code
# puts "evaluated_guesses: #{game.evaluated_guesses}"
