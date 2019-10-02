# Welcome -------------------------------------------------------------------
welcome <- paste(
  "/////////////////////////////",
  "// Welcome to Tic-Tac-Toe //",
  "///////////////////////////","",
  sep = "\n"
)

# Draw the board ------------------------------------------------------------
draw_board <- function(board) {
  board_text <- apply(
    board,
    MARGIN = 1,
    factor,
    levels = -1:1,
    labels = c("X","[]","O")
  )

  dimnames(board_text) <- list(paste("Row",1:3), paste("Col",1:3))

  print(board_text, quote = FALSE)
}

