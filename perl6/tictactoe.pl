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






#= A text-based tic-tac-toe game
class TicTacToe {
    has $!board;

    submethod BUILD() { 
	$!board = TTT-board.new();
    }

    method play() {
	say $!board.Str();

	while (True) {
	    my @players = "X","O"; # you can have any number of players

	    # - iterate over players -
	    for @players -> $player {


		# - loop untill player gives valid move -
		my $move-valid;
		while (!$move-valid) {
		    
		    # get player input
		    my $player-move = prompt("Player $player:");
		    
		    while ($player-move !~~ /<[1..9]>/) {
			$player-move = prompt("Player $player:");
		    }

		    # try to move
		    $move-valid = $!board.change-piece($player-move.Int,$player);
		    
		    if (!$move-valid) {
			say "spot taken! move again.";
		    }
		}


		# - print the board -
		say $!board.Str();


       		# - check for win -
		if (self!check-for-win($player) == 1) {
		    say "player $player wins!";
		    exit();
		}
	    }
	}
    }


    method !check-for-win(Str $player) {
	#rows
	for 1..3 -> $x {
	    if ($!board.pieces()[(1*$x)-1] &  
		$!board.pieces()[(2*$x)-1] & 
		$!board.pieces()[(3*$x)-1] eq $player) {
		
		return 1;
	    }
	}

	#cols
	for 0..2 -> $x {
	    if ($!board.pieces()[(1+$x)-1] &  
		$!board.pieces()[(4+$x)-1] & 
		$!board.pieces()[(7+$x)-1] eq $player) {
		
		return 1;
	    }
	}

	#diagnals
	if (($!board.pieces()[0] &
	    $!board.pieces()[4] &
	    $!board.pieces()[8]) 
	    | 
	    ($!board.pieces()[2] &
	    $!board.pieces()[4] &
	    $!board.pieces()[6]) eq $player) {
	    
	    return 1;
	}

	return 0;
    }
}

TicTacToe.new().play();





