use v6;

my enum MoveResult <Invalid GameEnd NextTurn>;

class Tic-Tac-Toe-Engine {
	 has @.board = ([0,0,0],
						 [0,0,0],
						 [0,0,0]);
	 has $.player-turn = 1;

	 method make-move (Int $y, Int $x) {
		  # make sure our argument is valid
		  if !(0 <= $y <= 8) |
			  !(0 <= $x <= 8) {
					return Invalid;
		  }
		  # make sure the space is empty
		  if @.board[$y][$x] > 0 {
				return Invalid;
		  }

		  #make the move
		  @!board[$y][$x] = $.player-turn;

		  #did that move end the game?
		  if self.game-winner {
				return GameEnd;
		  }

		  #swap players
		  if $.player-turn == 1 {
				$!player-turn = 2;
		  } else {
				$!player-turn = 1;
		  }
		  return NextTurn;
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
		  return -1;
	 }
}

class Tic-Tac-Toe-Text is Tic-Tac-Toe-Engine {
	 method make-move-single (Int $move){
		  if !(1 <= $move <= 9) {
				return Invalid;
		  }
		  my $y = ($move-1) div 3;
		  my $x = $move - $y*3 - 1;
		  return self.make-move($y,$x);
	 }

	 method Str {
		  my Str $string = "-------\n";
		  my Int $x = 1;
		  for 0..2 -> $i {
				for 0..2 -> $j {
					 $string ~= '|';
					 if @.board[$i][$j] == 1 {
						  $string ~= 'X';
					 } elsif @.board[$i][$j] == 2 {
						  $string ~= 'O';
					 } else {
						  $string ~= $x;
					 }
					 $x++;
				}
				$string ~= "|\n";
				$string ~= "-------\n";
		  }

		  return $string;
	 }
}

sub MAIN {
	 my $game = Tic-Tac-Toe-Text.new;

	 say "Welcome to Tic-Tac-Toe!";
	 while True {
		  say ~$game;
		  say "Player "~$game.player-turn~"'s move.";
		  my $result = Invalid;
		  while $result == Invalid {
				my $move = prompt "Your move? ";
				$result = $game.make-move-single(+$move);
		  }
		  
		  if $result == GameEnd {
				say "Game over!";
				if $game.game-winner == -1 {
					 say "No winner :(";
				} else {
					 say "Player "~$game.game-winner~" won!";
				}
				exit(0);
		  }
	 }
}
