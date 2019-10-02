check_for_bot <- function(names) {
  grepl("^computer$", names, ignore.case = TRUE)
}

test_candidate <- function(candidate, board) {
  board[candidate] <- 1
  get_margin_sums(board)
}

get_bot_move <- function(board, player) {

  # First turn should always be 2,2
  if (board[5] == 0) return(5)

  # Make it so active player is always 1 so we are always maximizing
  board <- board * get_player_marker(player)

  # Find out which spots are still open
  candidates <- which(board == 0)

  # Get margin sums for all candidates
  scores <- lapply(candidates, test_candidate, board)
  candidate_mins <- vapply(scores, min, numeric(1)) # Block
  candidate_maxs <- vapply(scores, max, numeric(1)) # Build

  # Choose a move from candidates available
  if (any(candidate_maxs == 3)) {
    # Go for the win
    choice <- which(candidate_maxs == 3)
  } else if (!isTRUE(all.equal(min(candidate_mins), max(candidate_mins)))) {
    # Block opponent advance
    choice <- which(candidate_mins == max(candidate_mins))
  } else {
    # Build a streak
    choice <- which.max(candidate_maxs)
  }

  candidates[choice]
}
