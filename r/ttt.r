##########################
#
# ttt.R
#
##########################
# 
# A naiive attempt at a tic-tac-toe game
# 
# Paul Egeler
# 
# 19 Dec 2016
#
##########################

tic.tac.toe = function () {
  
  ##################
  # Declarations
  ##################
  
  ####
  # Establish player names
  ####
  get.player.name.input = function(default) {
    
    player.name = 
      readline(prompt = paste0(
        "Please enter a name for ",
        default,
        ": "
      ))
    
    if (is.na(player.name) || player.name == "") 
      return(default)
    else 
      return(player.name)
    }
  
  get.player.names = function() {
    players = character(2)
    players[1] = get.player.name.input(default="Player 1")
    players[2] = get.player.name.input(default="Player 2")
    
    return(players)
  }
  
  ####
  # Get player moves
  ####
  
  get.player.move.input = function(player) {
  
    # Get the row number
    row = readline(prompt = paste0(
      player,
      ", please enter the row number of your next attack: "
    ))
    
    if (!grepl("[1-3]",row) || nchar(row) != 1) 
      return(get.player.move.input(player))
    
    # Get the column number
    col = readline(prompt = paste0(
      player,
      ", please enter the column number of your next attack: "
    ))
    
    if (!grepl("[1-3]",col) || nchar(col) != 1) 
      return(get.player.move.input(player))
    
    # Return inputs as an ordered pair
    return({(as.integer(row) - 1L) * 3L + as.integer(col)})
    
  }
  
  ####
  # Drawing the board
  ####
  
  draw.board = function(board) {
    board.text = apply(
       board, 
       MARGIN = 1, 
       factor, 
       levels = -1:1, 
       labels = c("X","[]","O")
       )
    
    row.names(board.text) = paste("Row",1:3)
    colnames(board.text)  = paste("Col",1:3)
    
    print(board.text, quote = FALSE)
  }
  
  ####
  # Checking for winner
  ####
  
  check.for.winner = function (board) {
    
    check.vals = c(
      rowSums(board),
      colSums(board),
      sum(diag(board)),
      sum(board[c(3,5,7)])
    )
    
    return({any(abs(as.integer(check.vals)) == 3L)})
  }
  
  
  ##################
  # Main
  ##################

  turn = 0
  winner = FALSE
  board = matrix(0,3,3)
  
  ####
  # Welcome screen
  ###
  cat("\r\n",
      "///////////////////////////// \r\n",
      "// Welcome to Tic-Tac-Toe // \r\n",
      "/////////////////////////// \r\n\n",
      "  Written by Paul Egeler \r\n",
      "      19 Dec 2016 \r\n\n",
      sep = ""
  )
   
  # Get player names
  players = get.player.names() 
  
  # And start the game off with player 1
  cat("OK ", players[1], ", let's get started \r\n\n", sep = "")
  
  # Show the  player the board
  draw.board(board)
  
  while (!winner && turn < 9) {
    
    # Determine which player gets a turn
    active.player = turn %% 2 + 1

    # Get the player's input
    if (turn < 8) {
      
      turn.coords = get.player.move.input(players[active.player])
    
    } else {
      
      turn.coords = which(board == 0)  
      
    }
    
    # Apply the move the the board
    if (board[turn.coords] == 0) {
      
      board[turn.coords] = ifelse(active.player == 1, -1, 1)
    
    } else {
      
      cat("Sorry, that spot is taken!!! Try again.\r\n", sep = "")
      
      next()
      
    }
    
    if (turn < 8) {
      
      # Congratulate the player on his courage
      cat(
          "\r\n",
          "Nice move, ",
          players[active.player], 
          ". The board looks like this now: \r\n\n",
          sep = ""
      )
    
    } else {
      
      # Tell them their fates are sealed
      cat(
          "\r\n",
          "Only one move left, and it goes to ",
          players[active.player], 
          ".\r\n The board looks like this now: \r\n\n",
          sep = ""
      )  
      
    }
    
    # Show the player the changes
    draw.board(board)
    
    # Check for winner
    winner = check.for.winner(board)
    
    # Increment turn number
    turn = turn + 1
  }
 
  if (winner)  {
    
    cat(
        "\r\n",
        "Well played, ",
        players[active.player], 
        ". You've won!!! \r\n",
        sep = ""
    )
    
    return(active.player)
    
  } else {
    
    cat("It was a draw. Better luck next time.\r\n", sep = "")
    
    return(0)
    
  }

}
