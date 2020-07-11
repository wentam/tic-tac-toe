from .game import Game
import pygame as pg
from sys import argv


def main():
    players = argv[-2:] if len(argv) == 3 else ["Player 1", "Player 2"]
    pg.display.init()
    pg.font.init()
    game = Game(players)
    game.run()
    pg.quit()

if __name__ == '__main__':
    main()