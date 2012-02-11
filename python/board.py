def print_board(p):
    print "_---------__---------___---------__"
    print "| 1       || 2       || 3       |"
    print "|         ||         ||         |"
    print "|    "+p[0][0]+"    ||    "+p[0][1]+"    ||    "+p[0][2]+"    |"
    print "|         ||         ||         |"
    print "|         ||         ||         |"
    print "_---------__---------__---------_"
    print "_---------__---------___---------__"
    print "| 4       || 5       || 6       |"
    print "|         ||         ||         |"
    print "|    "+p[1][0]+"    ||    "+p[1][1]+"    ||    "+p[1][2]+"    |"
    print "|         ||         ||         |"
    print "|         ||         ||         |"
    print "_---------__---------__---------_"
    print "_---------__---------___---------__"
    print "| 7       || 8       || 9       |"
    print "|         ||         ||         |"
    print "|    "+p[2][0]+"    ||    "+p[2][1]+"    ||    "+p[2][2]+"    |"
    print "|         ||         ||         |"
    print "|         ||         ||         |"
    print "_---------__---------__---------_"


def add_character_to_2d_array_with_linear_number(array,number,value):
    number = int(number)

    # columns
    cols = 3
    resulting_col = 0

    while (cols > 0):
        if (number == cols):
            resulting_col = number
        if (number-3 == cols):
            resulting_col = number-3
        if (number-6 == cols):
            resulting_col = number-6
            
        cols -= 1

    # rows
    rows = 3
    resulting_row = 0

    while (rows > 0):
        if (number == rows):
            resulting_row = 1
        if (number-3 == rows):
            resulting_row = 2
        if (number-6 == rows):
            resulting_row = 3
            
        rows -= 1

    if(array[resulting_row-1][resulting_col-1] == "X" or array[resulting_row-1][resulting_col-1] == "O"):
        return 0
    else:
        array[resulting_row-1][resulting_col-1] = value
        return array

def check_win(peices,player):
    
    # rows
    rows = 2
    rows_result = 0
    
    while (rows >= 0):
        if (peices[rows][0] == player and peices[rows][1] == player and peices[rows][2] == player):
            rows_result = 1
        rows -= 1


    # cols
    cols = 2
    cols_result = 0

    while (cols >= 0):
        if (peices[0][cols] == player and peices[1][cols] == player and peices[2][cols] == player):
            cols_result = 1
        cols -= 1 
        

    # diagnals
    d_result = 0
    if ((peices[0][0] == player and peices[1][1] == player and peices[2][2] == player) or (peices[0][2] == player and peices[1][1] == player and peices[2][0] == player)):
        d_result = 1


    # merge result
    result = 0
    if (cols_result == 1 or rows_result == 1 or d_result == 1):
        result = 1

    # return!
    return result
















