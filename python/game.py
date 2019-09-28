#!/usr/bin/env python3
import pygame as pg
import text
import colors
import logic


class Game:

    def __init__(self, players):
        # Initialize screen
        self.screen = pg.display.set_mode((960, 720))
        pg.display.set_caption("Tic Tac Toe")
        self.bbox = pg.Rect((0,0), (800, 600))
        self.bbox.center = self.screen.get_rect().center

        # Initialize variables
        self.quit = False
        self.turn = 0
        self.winner = False
        self.game_over = False
        self.board = [[0] * 3 for i in range(3)]
        self.cell_centers = logic.get_cell_centers(self.bbox)
        self.player_name = players
        self.player_click = False

        # Draw the board for the first time
        self.draw_board()
        pg.display.flip()

    # Drawing Routines -------------------------------------------------------
    def draw_board(self):
      # Clear screen
      self.screen.fill(colors.WHITE)

      # Draw title across the top
      text.draw(self.screen, (self.bbox.centerx, self.bbox.y - 3),
                30, colors.BLACK, "cb",
                "Tic Tac Toe")

      # Current turn status
      text.draw(self.screen, (self.bbox.right, self.bbox.bottom + 3),
                20, colors.BLACK, "rt",
               "Current turn: {}".format(self.turn + 1))

      # Current move status
      text.draw(self.screen, (self.bbox.left, self.bbox.bottom + 3),
                20, colors.BLACK, "lt",
                "Current move: {}".format(
                    self.player_name[logic.get_active_player(self.turn)]))

      # Grid
      for x in [self.bbox.left + i * self.bbox.width // 3 for i in (1,2)]:
          pg.draw.line(self.screen, colors.BLACK,
                       (x, self.bbox.top),(x, self.bbox.bottom), 5)
      for y in [self.bbox.top + i * self.bbox.height // 3 for i in (1,2)]:
          pg.draw.line(self.screen, colors.BLACK,
                       (self.bbox.left, y), (self.bbox.right, y), 5)

    def draw_pieces(self):
        for i in range(3):
            for j in range(3):
                if self.board[i][j] == 1:
                    rect = pg.Rect(0,0,120,120)
                    rect.center = self.cell_centers[i][j]
                    pg.draw.rect(self.screen, colors.RED, rect)
                if self.board[i][j] == -1:
                    pg.draw.circle(self.screen, colors.BLUE,
                                   self.cell_centers[i][j], 60)

    def draw_banner(self):
        rect = pg.Rect(0,0,500,100)
        rect.center = (self.bbox.centerx, self.bbox.centery - 20)
        pg.draw.rect(self.screen, colors.FUCHSIA, rect)
        if self.winner:
            message = "{} wins!".format(
                          self.player_name[logic.get_active_player(self.turn)])
        else:
            message = "It was a draw!"

        text.draw(self.screen, self.bbox.center, 50, colors.AQUA, "cb", message)

    # Master draw function
    def draw(self):
        self.draw_board()
        self.draw_pieces()
        if self.game_over:
            self.draw_banner()

    # Event Processing -------------------------------------------------------
    def process_event(self, event):
        if event.type == pg.QUIT:
            self.quit = True
        elif event.type == pg.MOUSEBUTTONUP and event.button == 1:
            self.player_input = event.pos
            self.player_click = True

    # Game 'logic' -----------------------------------------------------------
    def update(self):
        if self.player_click:
            self.player_click = False

            if self.bbox.collidepoint(self.player_input):
                x,y = logic.get_player_move(self.bbox, self.player_input)
                if self.board[x][y] == 0:
                    self.board[x][y] = -1 if logic.get_active_player(self.turn) else 1
                    self.winner = logic.check_for_winner(self.board)
                    if self.winner or self.turn == 8:
                        self.game_over = True
                    else:
                        self.turn += 1
                    return True

        return False

    # Run --------------------------------------------------------------------
    def run(self):
        while not self.quit:
            self.process_event(pg.event.wait())
            if not self.game_over:
                if self.update():
                  self.draw()
                  pg.display.flip()


if __name__ == '__main__':
    from sys import argv
    players = argv[-2:] if len(argv) == 3 else ["Player 1", "Player 2"]

    pg.display.init()
    pg.font.init()
    game = Game(players)
    game.run()
    pg.quit()
