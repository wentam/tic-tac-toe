# Tic Tac Toe

Text-based tic-tac-toe game.

## Installation

```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("pegeler/tic-tac-toe/R")
```

## Usage

From the R console:

``` r
ttt::tic_tac_toe()
```

or from the command line:

```bash
Rscript -e "ttt::tic_tac_toe()"
```

## Bot opponent(s)

If you enter *`computer`* as a player name, you can play against a bot. Or have
two bots play against each other.
