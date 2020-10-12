/*******************************************************************************
 * C++ implementation by Andrew Egeler
 *
 * Quick and dirty class / mutated state style of code, similar to my previous
 * implementations in other languages. Targeted at C++17.
 ******************************************************************************/

#include <iostream>
#include <exception>
#include <array>

using std::cout, std::array, std::invalid_argument, std::exception, std::string,
      std::cin, std::getline;

class bad_move : public exception {};

enum class player { X, O, NONE, UNKNOWN };

class board {
public:
    void make_move(player p, unsigned x, unsigned y) {
        if (board_at(x, y) != player::NONE)
            throw bad_move();
        else
            board_at(x, y) = p;
    }

    auto current_winner() -> const player {
        for (int i = 0; i <= 2; ++i) {
            if (players_match(board_at(0, i), board_at(1, i), board_at(2, i)))
                return board_at(0, i);
            if (players_match(board_at(i, 0), board_at(i, 1), board_at(i, 2)))
                return board_at(i, 0);
        }
        if (players_match(board_at(0, 0), board_at(1, 1), board_at(2, 2)))
            return board_at(0, 0);
        if (players_match(board_at(2, 0), board_at(1, 1), board_at(0, 2)))
            return board_at(2, 0);

        for(player p : _board)
            if (p == player::NONE)
                return player::UNKNOWN;

        return player::NONE;
    }

    const player at(unsigned x, unsigned y) { return _board[board_idx(x, y)]; }

private:
    array<player, 9> _board = {player::NONE, player::NONE, player::NONE,
                               player::NONE, player::NONE, player::NONE,
                               player::NONE, player::NONE, player::NONE};

    unsigned board_idx(unsigned x, unsigned y) {
        if (x < 0 || x > 2 || y < 0 || y > 2)
            throw invalid_argument("x and y must be 0 <= N <= 2 in board::make_move");
        return x + 3*y;
    }

    player& board_at(unsigned x, unsigned y) { return _board[board_idx(x, y)]; }

    bool players_match(player p1, player p2, player p3) {
        return p1 != player::NONE && p1 == p2 && p2 == p3;
    };
};

class text_engine {
public:
    player current_player = player::X;

    void display() {
        auto pos_char =
            [this](unsigned x, unsigned y) -> char {
                player p = game_board.at(x, y);
                return p == player::X ? 'X'
                       : p == player::O ? 'O'
                       : (x + 3*y) + 48 + 1;
            };

        cout << "-------\n";
        cout << '|' << pos_char(0, 0) << '|' << pos_char(1, 0) << '|' << pos_char(2, 0) << "|\n";
        cout << "-------\n";
        cout << '|' << pos_char(0, 1) << '|' << pos_char(1, 1) << '|' << pos_char(2, 1) << "|\n";
        cout << "-------\n";
        cout << '|' << pos_char(0, 2) << '|' << pos_char(1, 2) << '|' << pos_char(2, 2) << "|\n";
        cout << "-------\n";
    }

    player make_move() {
        string line;
        getline(cin, line);

        if(line.size() != 1)
            throw bad_move();
        if(line[0] < '1' || line[0] > '9')
            throw bad_move();

        unsigned move = (line[0] - 48) - 1;
        unsigned y = move / 3;
        unsigned x = move - 3*y;

        game_board.make_move(current_player, x, y);
        swap_player();
        return game_board.current_winner();
    }

private:
    board game_board;

    void swap_player() {
        if (current_player == player::X)
            current_player = player::O;
        else
            current_player = player::X;
    }
};

void display_win(text_engine g, player winner) {
    g.display();

    if (winner == player::X)
        cout << "X wins!\n";
    if (winner == player::O)
        cout << "O wins!\n";
    if (winner == player::NONE)
        cout << "Nobody wins.\n";
}

int main() {
    text_engine g;
    while (true) {
        try {
            g.display();
            cout << "Player " << (g.current_player == player::X ? 'X' : 'O') << ": ";
            player winner = g.make_move();

            if (winner != player::UNKNOWN) {
                display_win(g, winner);
                return 0;
            }
        }
        catch (bad_move&) {
            cout << "Invalid move, try again.\n";
        }
    }
}
