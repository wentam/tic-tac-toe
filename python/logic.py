def get_active_player(turn):
    return turn % 2

def get_cell_centers(bbox):
    x = [ bbox.x + x * bbox.width  // 6 for x in range(6) if x % 2 ]
    y = [ bbox.y + y * bbox.height // 6 for y in range(6) if y % 2 ]

    centers = []
    for i in range(3):
        row = []
        for j in range(3):
            row.append((x[i], y[j]))
        centers.append(row)

    return centers

def check_for_winner(board):
    check = [ sum(x) for x in board ]
    check.extend(map(sum, zip(*board)))
    check.append(sum([board[0][0], board[1][1], board[2][2]]))
    check.append(sum([board[0][2], board[1][1], board[2][0]]))

    return max([abs(x) for x in check]) == 3

def get_player_move(bbox, player_input):
    return ((player_input[0] - bbox.x) // (bbox.width   // 3),
            (player_input[1] - bbox.y) // (bbox.height  // 3))
