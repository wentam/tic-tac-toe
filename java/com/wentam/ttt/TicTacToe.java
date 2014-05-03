package com.wentam.ttt;

public class TicTacToe
{
    public static void main(String[] argv)
    {
        // create board and player objects
        Board board = new Board();
        Player players[] = new Player[2];
        players[0] = new Player("X");
        players[1] = new Player("O");

        // draw
        board.draw();

        // main loop
        int alt = 0;
        while (true) {
            // player alternator
            if (alt==0) {
                alt=1;
            } else if (alt == 1) {
                alt=0;
            }

            // take a turn, draw the board
            players[alt].takeTurn(board);
            board.draw();

            // win detection
            if (board.check_status(players[alt].getIdString())) {
                System.out.println("Player "+players[alt].getIdString()+" wins!");
                break;
            }
        }
    }
}
