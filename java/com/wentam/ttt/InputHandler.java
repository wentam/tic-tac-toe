package com.wentam.ttt;

import java.io.*;

public class InputHandler {
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
