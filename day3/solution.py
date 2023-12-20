from functools import reduce
'''
For this solution, I will treat the input as a 2d array. Each line of text will get added to the matrix ad a row.
Since strings are indexable with [], we do not need to actually make a 2d array but just a list of lines.
Then, we will iterate over every character in the matrix, row by row, and anytime we see a symbol (which is
any non-alphanumeric value), we will take note of its co-ordinates.

After constructing a list of all of the places where symbols occur, we will iterate over every one of those 
co-ordinates and check each of the adjacent index pairs. If an adjacent index pair is 1) in bounds, 2) a number
and most importantly 3) not already been visited, we will add it to a map where the index pair is the key. 
Condition 3 should ensure that we don't double count any values.

Then, we simply reduce the map values to a single sum and return.


I made a mistake. Adjacent numbers aren't only one digit adjacent to a symbol, but any digits adjacent to that digit.
So, I've added a function call get_adjacent_number() which takes the matrix and a point and finds the
full number adjacent to that point using two pointers.
But this breaks the map because now a number isn't described by just one point.
How to proceed? We could just give the co-ordinates starting from the leftmost digit. I think this would work w/o
any issues, we will see.

Issue was that we needed to index the return value of get_adjacent_number as one beyond the rightmost idx
'''
def generate_adjacent_points(point):
    row, col = point
    for i in range(row-1, row+2):
        for j in range(col-1, col+2):
            if (i,j) != point:
                yield (i,j)

def adjacent_value_is_number(matrix, point):
    i, j = point
    # First we check if the point is in bounds
    if i >=0 and i < len(matrix) and j >=0 and j < len(matrix[i]):
        value = matrix[i][j]
        return value.isnumeric()

def get_adjacent_number(matrix, point):
    i, j = point
    left = right = j
    while left >0 and matrix[i][left-1].isnumeric():
        left -= 1
    while right < len(matrix[i])-1 and matrix[i][right+1].isnumeric():
        right += 1

    value = int(matrix[i][left:right+1])
    return (value, left)

def check_adjacent_points(matrix, points):
    map = {}
    for point in points:
        for adjacent in generate_adjacent_points(point):
            if adjacent not in map and adjacent_value_is_number(matrix, adjacent):
                value, left = get_adjacent_number(matrix, adjacent)
                idx = (adjacent[0], left)
                map[idx] = value
    return map
        
matrix = []
symbol_locations = []
with open("input.txt") as input:
    for row, line in enumerate(input):
        line = line.rstrip("\n")
        matrix.append(line)
        for col, character in enumerate(line):
            if not character.isalnum() and not character == ".":
                symbol_locations.append((row,col))

map = check_adjacent_points(matrix, symbol_locations)
sum = reduce(lambda x,y: x + y, map.values())
print(sum)

'''
Part two:
We're going to iterate over the list of symbols.
If a symbol is a '*' character, then we will:
    a) create a map to store distinct adjacent numbers
    b) iterate over all the adjacent positions. If the
       adjacent position contains a number, we will 
       retrieve that number and add it to the map.
    c) if the map contains exactly two adjacent numbers,
       we have detected a gear. We will multiply the two
       numbers and add it to a list of gears.
    d) after iterating over the entire list of symbols,
       we simply reduce the list of gears and that is the
       result
'''
def find_gears(matrix, symbols):
    gears = []
    for symbol_location in symbols:
        i, j = symbol_location
        if matrix[i][j] == "*":
            adjacent_numbers = {}
            for adjacent in generate_adjacent_points(symbol_location):
                if adjacent_value_is_number(matrix, adjacent):
                    value, left = get_adjacent_number(matrix, adjacent)
                    idx = (adjacent[0], left)
                    adjacent_numbers[idx] = value
            if len(adjacent_numbers) == 2:
                ratio = reduce(lambda x,y: x*y, adjacent_numbers.values())
                gears.append(ratio)
    return gears

gear_sum = reduce(lambda x,y: x+y, find_gears(matrix, symbol_locations))
print(gear_sum) 
