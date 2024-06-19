# Mastermind

## Assignment instructions from The Odin Project (TOP)

Build a Mastermind game from the command line where you have 12 turns to guess the secret code, starting with you guessing the computer’s random code.

1. Think about how you would set this problem up!

2. Build the game assuming the computer randomly selects the secret colors and the human player must guess them. Remember that you need to give the proper feedback on how good the guess was each turn!

3. Now refactor your code to allow the human player to choose whether they want to be the creator of the secret code or the guesser.

4. Build it out so that the computer will guess if you decide to choose your own secret colors. You may choose to implement a computer strategy that follows the rules of the game or you can modify these rules.

5. If you choose to modify the rules, you can provide the computer additional information about each guess. For example, you can start by having the computer guess randomly, but keep the ones that match exactly. You can add a little bit more intelligence to the computer player so that, if the computer has guessed the right color but the wrong position, its next guess will need to include that color somewhere.

6. If you want to follow the rules of the game, you’ll need to research strategies for solving Mastermind, such as this [post](https://puzzling.stackexchange.com/questions/546/clever-ways-to-solve-mastermind).

## Instructions to play the game

A secret code of 4 colors (out of 6) will be chosen by the code creator. The guesser will try to guess the secret code by making entering their color choice.

If color and guessed position match with the secret code it is a full match which will be confirmed with a `+` symbol.

If the color appears in the secret code but the position does not match it is a fuzzy match which will be indicated by a `~` symbol.

In case computer has to guess the secret code, it will remember if in the previous choice a full match was found and guess the same color at same position again. All other guesses are random.