#!/usr/bin/env python3

import copy
import sys

with open(sys.argv[1] if len(sys.argv) == 2 else 'example' ) as file:
    data = file.read().strip().split("\n")

(width, height) = (len(data[0]), len(data))
total = 0
for y in range(height):
    for x in range(width):
        if data[y][x] != '@':
            continue
        count = 0
        for dx in [-1, 0, 1]:
            for dy in [-1, 0, 1]:
                px = x + dx
                py = y + dy
                if (px < 0) or (px >= width) or (py < 0) or (py >= height):
                    continue
                if data[py][px] == '@':
                    count += 1

        if count < 5:
            total += 1
print(f"Part 1: {total}")

grand_total = 0
array = [""] * height
while total > 0:
    total = 0
    for y in range(height):
        array[y] = ""
        for x in range(width):
            if data[y][x] != '@':
                array[y] += "."
                continue
            count = 0
            for dx in [-1, 0, 1]:
                for dy in [-1, 0, 1]:
                    px = x + dx
                    py = y + dy
                    if (px < 0) or (px >= width) or (py < 0) or (py >= height):
                        continue
                    if data[py][px] == '@':
                        count += 1

            if count < 5:
                total += 1
                array[y] += "."
            else:
                array[y] += "@"
    data = copy.deepcopy(array)
    grand_total += total
print(f"Part 2: {grand_total}")