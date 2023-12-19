import re
from functools import reduce

numbers = "one|two|three|four|five|six|seven|eight|nine"
digits = {}
i = 1
for digit in numbers.split("|"):
    digits[digit] = str(i)
    i += 1

def convertToDigit(match):
    if match in digits:
        return digits[match]
    else:
        return match

with open("input.txt") as input:
    lines = input.readlines()
    sum = 0
    regexString = r"(?=(\d|" + numbers + r"))"
    regex = re.compile(regexString)

    for i,line in enumerate(lines):
        matches = re.findall(regex, line)
        matches = list(map(convertToDigit, matches))
        first, last = matches[0], matches[-1]
        sum += int(first + last)

print(sum)
