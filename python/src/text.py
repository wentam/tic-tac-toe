import pygame


def draw(screen, pos, size, color, alignment, string):

    font = pygame.font.Font(None, size)
    font_dim = font.size(string)

    if alignment[0] == "l":
        x_offset = 0
    elif alignment[0] == "c":
        x_offset = font_dim[0] // 2
    elif alignment[0] == "r":
        x_offset = font_dim[0]
    else:
        raise Exception

    y_offset = 0 if alignment[1] == "t" else font_dim[1]

    screen.blit(font.render(string, True, color),
                [pos[0] - x_offset, pos[1] - y_offset])
