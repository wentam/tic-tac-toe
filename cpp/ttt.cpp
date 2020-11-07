/*******************************************************************************
 * C++ implementation by Andrew Egeler
 *
 * Quick and dirty class / mutated state style of code, similar to my previous
 * implementations in other languages. Targeted at C++17.
 ******************************************************************************/

#include <iostream>
#include <exception>
#include <array>
#include <algorithm>

using std::cout, std::array, std::invalid_argument, std::exception, std::string,
      std::cin, std::getline, std::any_of;

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

    player current_winner() {
        auto check_rows_cols =
            [this]() -> player {
                player p = player::NONE;
                for (int i = 0; i <= 2; ++i) {
                    if (players_match(board_at(0, i), board_at(1, i), board_at(2, i)))
                        p = board_at(0, i);
                    if (players_match(board_at(i, 0), board_at(i, 1), board_at(i, 2)))
                        p = board_at(i, 0);
                }
                return p;
            };

        auto check_diagonals =
            [this]() -> player {
                if (players_match(board_at(0, 0), board_at(1, 1), board_at(2, 2)))
                    return board_at(0, 0);
                else if (players_match(board_at(2, 0), board_at(1, 1), board_at(0, 2)))
                    return board_at(2, 0);
                else
                    return player::NONE;
            };

        player p;
        if ((p = check_rows_cols()) != player::NONE)
            return p;
        else if ((p = check_diagonals()) != player::NONE)
            return p;
        else if (is_board_full())
            return player::NONE;
        else
            return player::UNKNOWN;
    }

    player at(unsigned x, unsigned y) { return _board[board_idx(x, y)]; }

private:
    array<player, 9> _board = {player::NONE, player::NONE, player::NONE,
                               player::NONE, player::NONE, player::NONE,
                               player::NONE, player::NONE, player::NONE};

    unsigned board_idx(unsigned x, unsigned y) {
        if (x < 0 || x > 2 || y < 0 || y > 2)
            throw invalid_argument("x and y must be 0 <= N <= 2 in board::make_move");
        else
            return x + 3*y;
    }

    player& board_at(unsigned x, unsigned y) { return _board[board_idx(x, y)]; }

    bool players_match(player p1, player p2, player p3) {
        return p1 != player::NONE && p1 == p2 && p2 == p3;
    };

    bool is_board_full() {
        bool any_blank = any_of(
            _board.begin(), _board.end(), [](player p){return p == player::NONE;}
        );
        return !any_blank;
    }
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
        else if(line[0] < '1' || line[0] > '9')
            throw bad_move();
        else {
            unsigned move = (line[0] - 48) - 1;
            unsigned y = move / 3;
            unsigned x = move - 3*y;

            game_board.make_move(current_player, x, y);
            swap_player();
            return game_board.current_winner();
        }
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
    else if (winner == player::O)
        cout << "O wins!\n";
    else if (winner == player::NONE)
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
