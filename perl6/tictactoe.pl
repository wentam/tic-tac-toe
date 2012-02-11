use v6;

#= Manages the pieces of a tic-tac-toe board, and creates a string to represent it
class TTT-board {
    has @.pieces;

    submethod BUILD () { 
	@!pieces =  	  
	    " "," "," ",
    	    " "," "," ",
     	    " "," "," "; 
    }

    #= changes a piece on the board (Int location, String value).
    method change-piece(Int $location,Str $value) {	
	if (@!pieces[$location-1] eq " ") {
	    @!pieces[$location-1] = $value;
	    return 1;
	} else {
	    return 0;
	}
    }

    #= returns a string that represents the board
    method Str() {
	return
	    "+-------+-------+-------+\n" ~
	    "|1      |2      |3      |\n" ~
	    "|   @!pieces[0]   |   @!pieces[1]   |   @!pieces[2]   |\n" ~
	    "|       |       |       |\n" ~
	    "+-------+-------+-------+\n" ~
	    "|4      |5      |6      |\n" ~
	    "|   @!pieces[3]   |   @!pieces[4]   |   @!pieces[5]   |\n" ~
	    "|       |       |       |\n" ~
	    "+-------+-------+-------+\n" ~
	    "|7      |8      |9      |\n" ~
	    "|   @!pieces[6]   |   @!pieces[7]   |   @!pieces[8]   |\n" ~
	    "|       |       |       |\n" ~
	    "+-------+-------+-------+\n";
    }
}



#= calculations for tic-tac-toe
class TTT-calc {
    method check-for-win(@board,$player) {
	for 0..2 {
	    
	    #rows
	    if (@board[(1 + ($_ * 3))-1] &
		@board[(2 + ($_ * 3))-1] &
		@board[(3 + ($_ * 3))-1] eq $player) {
		
		return True;
	    }
	    
	    #cols
	    if (@board[(1+$_)-1] &  
		@board[(4+$_)-1] & 
		@board[(7+$_)-1] eq $player) {
		
		return True;
	    }
	}
		
	#diagnals
	if ((@board[0] &
	     @board[4] &
	     @board[8]) 
	    | 
	    (@board[2] &
	     @board[4] &
	     @board[6]) eq $player) {
	    
	    return True;
	}
	return False;	
    }
}



#= A text-based tic-tac-toe game
class TicTacToe {
    has $!board;
    has $!calc;

    submethod BUILD() { 
	$!board = TTT-board.new();
	$!calc = TTT-calc.new();
    }

    method play() {
	say $!board.Str();

	while (True) {
	    my @players = "X","O"; # you can have any number of players

	    # - iterate over players -
	    for @players -> $player {

		self!move-via-user-input($player);

		# - print the board -
		say $!board.Str();

       		# - check for win -
		if ($!calc.check-for-win($!board.pieces(), $player)) {
		    say "player $player wins!";
		    exit();
		}
	    }
	}
    }

    method !move-via-user-input(Str $player) {
	my $move-valid;
	my $player-move;

	while (!$move-valid) {

	    # get player input
	    $player-move = prompt("Player $player:");
	    
	    # loop untill the user gives us a good value
	    while ($player-move !~~ /<[1..9]>/) {
		$player-move = prompt("Player $player:");
	    }
	    
	    # try to move
	    $move-valid = $!board.change-piece($player-move.Int,$player);
	    
	    # feedback if spot taken
	    if (!$move-valid) {
		say "spot taken! move again.";
	    }
	}

	return $player-move;
    }
}

TicTacToe.new().play();
