require "colorize"

class Game
  attr_reader :players, :colors
  attr_accessor :secret_code, :all_guesses, :turn, :evaluated_guesses

  def initialize(player1, player2)
    @colors = ["yellow", "blue", "magenta", "red", "green", "cyan"]
    @secret_code = Array.new(4)
    @turn = 0
    @players = [player1.new(self, "You"), player2.new(self, "Computer")] # self here is referencing the game object
    @all_guesses = Array.new(12) { Array.new(4, " ") }
    @evaluated_guesses = Array.new(12) { Array.new(4, " ") }
  end

  def start_game
    role_human = HumanPlayer.request_preferred_role

    if role_human == "g"
      play(players[0], players[1])
    else
      play(players[1], players[0])
    end
  end

  def play(guesser, code_creator)
    self.secret_code = code_creator.choose_secret_code
    visualize_board

    12.times do
      play_one_round(guesser)
      return puts "#{guesser.form_of_address} guessed the code!!! #{guesser.form_of_address} won." if check_for_win
    end

    puts "#{guesser.form_of_address} lost. The secret code was #{secret_code}"
  end

  def check_for_win
    evaluated_guesses[turn - 1].all? { |guess| guess == "+" }
  end

  def play_one_round(guesser)
    all_guesses[turn] = guesser.make_guess
    evaluate_guess
    visualize_board
    self.turn += 1
  end

  def evaluate_guess
    check_for_full_match
    check_for_fuzzy_match
    evaluated_guesses
  end

  def check_for_full_match
    all_guesses[self.turn].each_with_index do |color_guessed, guessed_position|
      evaluated_guesses[self.turn][guessed_position] = "+" if color_guessed == secret_code[guessed_position]
    end
  end

  def check_for_fuzzy_match
    all_guesses[self.turn].each_with_index do |color_guessed, guessed_position|
      next unless evaluated_guesses[self.turn][guessed_position] != "+"

      secret_code.each_with_index do |secret_color, secret_position|
        if color_guessed == secret_color && evaluated_guesses[self.turn][secret_position] != "+"
          evaluated_guesses[self.turn][guessed_position] = "~"
        end
      end
    end
  end

  def visualize_board
    line_number = 12

    while line_number > 0
      if all_guesses[line_number - 1].all? { |color| color != " " }
        display_guess_and_evaluation(line_number)
      else
        puts "    |   ||   |   |   |   ||   |   Turn #{line_number}"
      end
      line_number -= 1
    end
    puts "           1   2   3   4 "
  end

  def display_guess_and_evaluation(line_number)
    puts "  #{evaluated_guesses[line_number - 1][0]} | #{
      evaluated_guesses[line_number - 1][1]} || #{
      ' '.colorize(background: all_guesses[line_number - 1][0].to_sym)} | #{
      ' '.colorize(background: all_guesses[line_number - 1][1].to_sym)} | #{
      ' '.colorize(background: all_guesses[line_number - 1][2].to_sym)} | #{
      ' '.colorize(background: all_guesses[line_number - 1][3].to_sym)} || #{
      evaluated_guesses[line_number - 1][2]} | #{
      evaluated_guesses[line_number - 1][3]} Turn #{line_number}"
  end

  def display_colors_of_pins
    puts "The pin colors are: #{
      colors[0]}, #{
      colors[1]}, #{
      colors[2]}, #{
      colors[3]}, #{
      colors[4]} and #{
      colors[5]}."
  end
end

class Player
  attr_reader :game

  def initialize(game, form_of_address)
    @form_of_address = form_of_address
    @game = game
  end

  def make_guess
    game.display_colors_of_pins
    puts
    guess = Array.new(4)
    get_guess(guess)
    guess
  end
end

class HumanPlayer < Player
  attr_reader :form_of_address

  def self.request_preferred_role
    loop do
      puts "Do you want to create the secret code (C) or do you want to guess the code (G)?
      Please enter the corresponding letter:"

      human_role = gets.chomp.downcase
      break human_role if ["c", "g"].include?(human_role)

      puts "Invalid choice. Please try again."
    end
  end

  def choose_secret_code
    puts "You can choose from the following pin colors: #{game.colors}."

    index = 0
    while index < 4
      choose_one_secret_color(index)
      index += 1
    end
    game.secret_code
  end

  def choose_one_secret_color(index)
    loop do
      puts "Please enter your color choice for Position #{index + 1}:"
      game.secret_code[index] = gets.chomp
      break game.secret_code[index] if game.colors.game_colors_includes_color_choice

      puts "Invalid choice. Please try again."
    end
  end

  def game_colors_includes_color_choice?
    game.colors.include?(game.secret_code[index])
  end

  def get_guess(guess)
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
  attr_reader :form_of_address

  def choose_secret_code
    game.secret_code.map { game.colors.sample }
  end

  def get_guess(guess)
    index = 0
    while index < 4
      loop do
        puts "Please enter your guess for Position #{index + 1}:"
        guess[index] = game.colors.sample
        break guess[index] if game.colors.include?(guess[index])

        puts "Invalid choice. Please try again."
      end
      index += 1
    end
  end
end

Game.new(HumanPlayer, ComputerPlayer).start_game
