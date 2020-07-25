from . import logic
import re
from copy import deepcopy


def check_for_bot(names):
    return [ bool(re.search('^computer$', x)) for x in names ]

def make_test_board(board, turn):
    marker = logic.get_player_marker(turn)
    tmp = deepcopy(board)
    for i in range(3):
        for j in range(3):
            tmp[i][j] = tmp[i][j] * marker
    return tmp

def find_candidates(board):
    candidates = []
    for i in range(3):
        for j in range(3):
            if board[i][j] == 0: candidates.append([i,j])
    return candidates

def test_candidate(i, j, board):
    tmp = deepcopy(board)
    tmp[i][j] = 1
    return logic.get_margin_sums(tmp)

def score_candidates(candidates, board):
    scores = []
    for i, j in candidates:
        scores.append(test_candidate(i, j, board))
    return scores

def get_mins(scores):
    return [ min(x) for x in scores ]

def get_maxs(scores):
    return [ max(x) for x in scores ]

def get_bot_move(board, turn):

    # Middle is a safe defensive position
    if board[1][1] == 0: return 1, 1

    # Find remaining open spaces
    candidates = find_candidates(board)

    # Make a copy of the board to play with
    test_board = make_test_board(board, turn)

    # Get scores for all candidates
    scores = score_candidates(candidates, test_board)
    mins = get_mins(scores)
    maxs = get_maxs(scores)

    # Choose a move from candidates available
    if 3 in maxs:                        # Go for the win
        choice = [ i for i, v in enumerate(maxs) if v == 3 ]
    elif min(mins) != max(mins):         # Block opponent advance
        choice = [ i for i, v in enumerate(mins) if v == max(mins) ]
    else:                                # Build a streak
        choice = [ i for i, v in enumerate(maxs) if v == max(maxs) ]

    return candidates[choice[0]]
