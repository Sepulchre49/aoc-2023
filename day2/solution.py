import re
from enum import Enum
from functools import reduce

MaxCounts = {
    "red":   12,
    "green": 13,
    "blue":  14
}
def parse_game_data(data):
    data = data.split(";")
    game = []
    for frame in data:
        set = []
        for cube in re.finditer(r"(\d+) (red|green|blue)", frame):
            count, color = int(cube.group(1)), cube.group(2)
            set.append((color, count))
        game.append(set)

    return game

def game_is_valid(game):
    for set in game:
        for cube in set:
            color, count = cube 
            if count > MaxCounts[color]:
                return False
    return True

def min_possible_game(game):
    r = g = b = 0
    for set in game:
        for cube in set:
            color, count = cube
            if color == "red" and count > r:
                r = count
            elif color == "green" and count > g:
                g = count
            elif color == "blue" and count > b:
                b = count
    return (r,g,b)


sum = 0
sum_of_powers = 0

with open("input.txt") as input:
    for line in input:
        line = line.rstrip("\n")
        _, gameNo, data = re.split(r"(\d+): ", line) # Get current game # and data
        gameNo = int(gameNo)
        game = parse_game_data(data)
        
        if game_is_valid(game):
            sum += gameNo

        min = min_possible_game(game)
        power = reduce(lambda a,b: a*b, min)
        sum_of_powers += power

print(sum)
print(sum_of_powers)
