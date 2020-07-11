from .game import Game
import pygame as pg
from sys import argv


def tic_tac_toe(players):
    pg.display.init()
    pg.font.init()
    game = Game(players)
    game.run()
    pg.quit()

def main():
    players = argv[-2:] if len(argv) == 3 else ["Player 1", "Player 2"]
    tic_tac_toe(players)
