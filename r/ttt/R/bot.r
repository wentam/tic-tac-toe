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

  # Block
  mins <- vapply(candidates, function(x) min(test_candidate(x, board)), numeric(1))
  if (any(mins != max(mins))) return(candidates[which(mins == max(mins))])

  # Build
  maxs <- vapply(candidates, function(x) max(test_candidate(x, board)), numeric(1))

  candidates[which.max(maxs)]
}
