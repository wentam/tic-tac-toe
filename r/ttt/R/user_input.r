# Command line input --------------------------------------------------------
get_user_input <- function(prompt) {
  if (interactive()) {
    readline(prompt)
  } else {
    cat("\n", prompt, sep = "")
    readLines("stdin", n = 1L)
  }
}

# Player names --------------------------------------------------------------
get_player_name <- function(default) {
  player_name <- get_user_input(sprintf("Please enter a name for %s: ", default))
  if (player_name > "") player_name else default
}

get_player_names <- function() {
  vapply(1:2, function(x) get_player_name(paste("Player", x)), character(1))
}

# Player moves --------------------------------------------------------------
move_message <- function(player, dimension = c("row", "column")) {
  sprintf(
    "%s, please enter the %s number of your next attack: ",
    player,
    match.arg(dimension)
  )
}

validate_move <- function(input) {
  if (!grepl("[1-3]", input) || nchar(input) != 1) {
    print_message("Bad input! Try again...")
    return(FALSE)
  }
  TRUE
}

get_player_move <- function(player) {

  # Get the row number
  row <- get_user_input(move_message(player, "r"))
  if (!validate_move(row)) return(get_player_move(player))

  # Get the column number
  col <- get_user_input(move_message(player, "c"))
  if (!validate_move(col)) return(get_player_move(player))

  # Return index number
  {(as.integer(row) - 1L) * 3L + as.integer(col)}

}
