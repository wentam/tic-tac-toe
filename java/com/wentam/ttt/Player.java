package com.wentam.ttt;

public class Player
{
    private InputHandler input = new InputHandler();
    private String idString;

    public Player(String idString) {
        this.idString = idString;
    }

    public String getIdString() {
        return this.idString;
    }

    public void takeTurn(Board board) {
        System.out.print("Player "+idString+":");
        int in = Integer.parseInt(input.string_input());
        board.add_entry(idString,in-1);
    }
}
