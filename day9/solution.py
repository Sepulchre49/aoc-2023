from functools import reduce
from concurrent.futures import ProcessPoolExecutor as PPE

data = []

with open("input.txt") as file:
    for line in file:
        line = line.strip().split()
        seq = list(map(lambda x: int(x), line))
        data.append(seq)
        

def sequenceIsZero(sequence):
    for i in sequence:
        if i != 0:
            return False
    return True


def extrapolate(sequence):
    tree = [ sequence ] 

    current = sequence
    while not sequenceIsZero(current):
        next = []
        i = 1
        while i < len(current):
            next.append(current[i] - current[i-1])
            i += 1
        current = next
        tree.append(current)

    tree[-1].append(0)

    i = len(tree) - 1
    while i > 0:
        j = len(tree[i]) - 1
        tree[i-1].append(tree[i][j] + tree[i-1][j])
        i -= 1
        j += 1

    return tree[0][-1]

def extrapolate2(sequence):
    tree = [ sequence ] 

    current = sequence
    while not sequenceIsZero(current):
        next = []
        i = 1
        while i < len(current):
            next.append(current[i] - current[i-1])
            i += 1
        current = next
        tree.append(current)

    tree[-1].append(0)

    i = len(tree) - 1
    while i > 0:
        tree[i-1].insert(0, tree[i-1][0] - tree[i][0])
        i -= 1

    return tree[0][0]

sum = 0
with PPE() as executor:
    results = executor.map(extrapolate, data)
    sum = reduce(lambda x,y: x+y, results)

print(sum)

sum = 0
with PPE() as executor:
    results = executor.map(extrapolate2, data)
    sum = reduce(lambda x,y: x+y, results)

print(sum)
