print_message <- function(...) {
  cat(..., "\n", sep = "")
}

get_confirm_message <- function(player_name, turn) {
  message <- sprintf(if (turn < 8) "Nice move, %s."
                     else "Only one move left, and it goes to %s",
                     player_name)

  paste0("\n", message, "\nThe board looks like this now:\n")
}
