#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int width, height, cell_width, player_count;
int board_state[256*256]; // Values are player number+1, 0 for empty

void pc(char c)        { putc(c, stdout);                                                         }
char playerc(int p)    { return 'A'+p;                                                            }
void pn(char c, int n) { for (int i = 0; i < n; i++) putc(c, stdout);                             }
void hdiv()            { pn('-', (cell_width*width)+(width*3)+1); pc('\n');                       }
void clear()           { printf("\033[H\033[2J");                                                 }
void full_cell(int p)  { printf(" %0*c |", cell_width, playerc(p));                               }
void empty_cell(int c) { printf(" %0*d |", cell_width, c);                                        }
void cell(int c)       { (board_state[c] == 0) ? empty_cell(c) : full_cell(board_state[c]-1);     }
void row(int s)        { pc('|'); for (int i = 0; i < width; i++) cell(s+i); pc('\n'); hdiv();    }
void view()            { clear(); hdiv(); for (int i = 0; i < height; i++) row(i*width);          }
void wexit(int p)      { view(); printf("%c wins!\n", playerc(p)); exit(0);                       }
int  validpos(int p)   { return !(p >= width*height || board_state[p] != 0);                      }
void flush_stdin()     { int c; while ((c = getchar()) != '\n' && c != EOF) { };                  }
int  int_in()          { int r; while (scanf("%d", &r) == 0) { flush_stdin(); }; return r;        }
int  user_in(char c)   { int m = -1; while(!validpos(m)){printf("%c:",c);m = int_in();} return m; }
void turn(int p)       { board_state[user_in(playerc(p))] = p+1;                                  }

void _win_search(int step, int matches_required, int left_stop, int right_stop) {
  for (int i = 0; i < width*height; i++) {
    int len = 1;
    for (int j = step; j < matches_required*step && i+j < width*height; j += step) {
      if ((left_stop && (i+j % width == width-1)) || (right_stop && (i+j % width == 0))) break;
      if (board_state[i+j] == board_state[i]) len++;
    }

    if (board_state[i] != 0 && len == matches_required) wexit(board_state[i]-1);
  }
}

void check_for_winner() {
  _win_search(1,     width,  0, 1);               // Rows
  _win_search(width, height, 0, 0);               // Cols
  _win_search(width+1, fmin(width,height), 0, 1); // Downward-sloping diagnals
  _win_search(width-1, fmin(width,height), 1, 0); // Upward-sloping diagnals
}

int main(int argc, char* argv[]) {
  if (argc < 4) { puts("Usage: ttt [width] [height] [player count]"); exit(0); }
  width        = ((atoi(argv[1]) == 0 || atoi(argv[1]) > 256) ? 3 : atoi(argv[1]));
  height       = ((atoi(argv[2]) == 0 || atoi(argv[2]) > 256) ? 3 : atoi(argv[2]));
  player_count = ((atoi(argv[3]) == 0 || atoi(argv[3]) > 26)  ? 2 : atoi(argv[3]));
  cell_width   = ceil(log10(width*height));

  for (int i = 0; 1; i++) { view(); turn(i % player_count); check_for_winner(); }
}
