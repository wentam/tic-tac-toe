import board
import sys

peices =  [[' ',' ',' '],[' ',' ',' '],[' ',' ',' ']]


board.print_board(peices);

gameRunning = 1

while (gameRunning == 1):
    move = raw_input('Player X: ')
    result = board.add_character_to_2d_array_with_linear_number(peices,move,"X")
    if (result != 0):
        peices = result
        board.print_board(peices);
    else:
        print "bad boy. no stealing spots! you forfeit your turn."

    result = board.check_win(peices,"X")
    if (result == 1):
        print "Player X wins"
        sys.exit()
    
    move = raw_input('Player O: ')
    result = board.add_character_to_2d_array_with_linear_number(peices,move,"O")
    
    if (result != 0):
        peices = result
        board.print_board(peices);
    else:
        print "bad boy. no stealing spots! you forfeit your turn."


    result = board.check_win(peices,"O")
    if (result == 1):
        print "Player O wins"
        sys.exit()
