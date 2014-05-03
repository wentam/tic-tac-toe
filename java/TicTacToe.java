import java.io.*;

public class TicTacToe
{
    public static void main(String[] argv)
    {
        Board board = new Board();
        board.draw();

        Player player = new Player();

        boolean gameRunning = true;

        int alt = 2;

        while (gameRunning == true) {
            boolean result = false;

            //player alternator
            if (alt==1) {
                alt=2;
            } else {
                if (alt==2) {
                    alt=1;
                }
            }


            // take a turn!
            result = player.takeTurn(alt,board);

            if (result == true) {
                break;
            }
        }
    }
}

class Player
{
    InputHandler input = new InputHandler();

    public boolean takeTurn(int player,Board board) {
        boolean result = false;

        if (player == 1) {
            System.out.print("Player X:");
            int in = Integer.parseInt(input.string_input());

            board.add_entry("X",in-1);
            board.draw();

            result = board.check_status("X");
            if (result == true) {
                System.out.println("Player X wins!");
            }
        }

        if (player == 2) {
            System.out.print("Player O:");
            int in = Integer.parseInt(input.string_input());

            board.add_entry("O",in-1);
            board.draw();

            result = board.check_status("O");
            if (result == true) {
                System.out.println("Player O wins!");
            }
        }
        return result;
    }
}

class Board
{
    String v[] = {" "," "," "," "," "," "," "," "," "};

    public int draw()
    {
        System.out.println("\033[2J\n"); // clear screen

        String[] line = {
            "_____________",
            "|1  |2  |3  |",
            "| "+v[0]+" | "+v[1]+" | "+v[2]+" |",
            "|___|___|___|",
            "|4  |5  |6  |",
            "| "+v[3]+" | "+v[4]+" | "+v[5]+" |",
            "|___|___|___|",
            "|7  |8  |9  |",
            "| "+v[6]+" | "+v[7]+" | "+v[8]+" |",
            "|___|___|___|"

        };

        for (String entry : line) {
            System.out.println(entry);
        }
        return 1;
    }

    public boolean check_status(String player) {
        boolean result = false;

        // check columns
        int column = 1;
        while (column <=3) {
            if (v[column-1]==player && v[column+2]==player && v[column+5]==player) {result = true;}
            column +=1;
        }

        // check rows
        int increment[] = {0,1,2};
        while (increment[2] <= 8) {
            if (v[increment[0]]==player && v[increment[1]]==player && v[increment[2]]==player) {result = true;}
            for (int i = 0; i<=2; i++) {
                increment[i] += 3;
            }
        }

        // check diagnals
        if (v[0]==player && v[4]==player && v[8]==player) {result = true;}
        if (v[2]==player && v[4]==player && v[6]==player) {result = true;}


        return result;
    }

    public int add_entry(String letter, int location)
    {
        boolean space_open = true;

        // if the space is open
        if (v[location].equals("X") || v[location].equals("O")) {
            space_open = false;
        }

        if (space_open == true) {
            v[location] = letter;
        }
        return 1;
    }
}

class InputHandler {
    public String string_input() {
        String userInput;
        userInput = new String();

        try {
            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            userInput = in.readLine();
        }catch(IOException e){} // TODO

        return userInput;
    }
}


