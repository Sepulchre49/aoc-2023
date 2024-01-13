#!/usr/bin/env python3
import re

instructions = []
graph = {}

with open("input.txt") as input:
    for line in input.readlines():
        line = line.strip()

        instruction = re.search(r"^[LR]+$", line)
        edge = re.match(r"([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)", line)

        if instruction:
            instructions = list(instruction[0])
        if edge:
            src, left, right = edge.group(1,2,3)
            graph[src] = (left, right)

i = 0
count = 0
current = "AAA"
while current != "ZZZ":
    direction = instructions[i]
    current = graph[current][0] if direction == "L" else graph[current][1]
    count = count + 1
    i = (i+1) % len(instructions)

print(count)
