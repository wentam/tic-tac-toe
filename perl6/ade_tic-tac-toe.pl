use v6;

enum MoveResult <invalid gameend nextturn>;

class Tic-Tac-Toe-Engine {
	 has @.board = ((0,0,0),
						 (0,0,0),
						 (0,0,0));
	 has $.player-turn = 1;

	 method make-move (Array @op) {
		  # make sure our argument is valid
		  if !(@op[0] ~~ Int & 1 <= @op[0] <= 9) |
			  !(@op[1] ~~ Int & 1 <= @op[1] <= 9) {
					return MoveResult.invalid;
		  }
		  # make sure the space is empty
		  if @.board[@op[0]][@op[1]] > 0 {
				return MoveResult.invalid;
		  }

		  #make the move
		  @!board[@op[0]][@op[1]] = $.player-turn;

		  #did that move end the game?
		  if self.game-winner != False {
				return MoveResult.gameend;
		  }

		  #swap players
		  if $.player-turn == 1 {
				$!player-turn = 2;
		  } else {
				$!player-turn = 1;
		  }
		  return MoveResult.nextturn;
	 }

	 method game-winner {

		  # scan rows & columns
		  for 0..2 {
				if @.board[$_][0] == @.board[$_][1] == @.board[$_][2] {
					 return @.board[$_][0];
				}
				
				if @.board[0][$_] == @.board[1][$_] == @.board[2][$_] {
					 return @.board[0][$_];
				}
		  }

		  # scan diagonals
		  if @.board[0][0] == @.board[1][1] == @.board[2][2] {
				return @.board[0][0];
		  }
		  if @.board[0][2] == @.board[1][1] == @.board[2][0] {
				return @.board[0][2];
		  }

		  # check for empty spaces for next move
		  for 0..2 -> $i {
				for 0..2 -> $j {
					 if @.board[$i][$j] == 0 {
						  #no winner, empty spaces left on board
						  return False;
					 }
				}
		  }
		  
		  #board is full with no winner
		  return 0;
	 }
}
