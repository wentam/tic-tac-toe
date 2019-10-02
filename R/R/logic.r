get_active_player <- function(turn){
  turn %% 2 + 1
}

get_move_index <- function(row, col) {
  (as.integer(row) - 1L) * 3L + as.integer(col)
}

get_player_marker <- function(player) {
  ifelse(player == 1, -1, 1)
}

get_margin_sums <- function(board) {
  c(
    rowSums(board),
    colSums(board),
    sum(diag(board)),
    sum(board[c(3,5,7)])
  )
}

check_for_winner <- function(board) {
  any(abs(get_margin_sums(board)) == 3)
}
