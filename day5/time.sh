#!/bin/bash

# Number of iterations
iterations=10

# Initialize total time
total_time=0

# Run the command in a loop
for ((i = 1; i <= iterations; i++)); do
    # Capture the start time
    start_time=$(date +%s.%N)

    # Run Lua script
    lua solution_pt2.lua >/dev/null

    # Capture the end time
    end_time=$(date +%s.%N)

    # Calculate the real time in seconds
    real_time=$(echo "$end_time - $start_time" | bc -l)

    # Add the real time to the total time
    total_time=$(echo "$total_time + $real_time" | bc -l)
done

# Calculate the average time
average_time=$(echo "scale=3; $total_time / $iterations" | bc -l)

echo "Average runtime: $average_time seconds"
