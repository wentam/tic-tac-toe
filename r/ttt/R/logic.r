get_active_player <- function(turn){
  turn %% 2 + 1
}

check_for_winner <- function(board) {

  check <- c(
    rowSums(board),
    colSums(board),
    sum(diag(board)),
    sum(board[c(3,5,7)])
  )

  {any(abs(as.integer(check)) == 3L)}
}
