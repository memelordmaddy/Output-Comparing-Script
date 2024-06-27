#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <program.cpp> <input.txt> <expected_output.txt>"
    exit 1
fi

# Assign input arguments to variables
program=$1
input=$2
expected_output=$3

# Compile the C++ program
g++ -o program.out $program
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

# Run the program with input from input.txt and save the output
./program.out < $input > actual_output.txt

# Check line-by-line using awk
output_matches=$(awk 'NR==FNR{a[FNR]=$0;next} {if (a[FNR] != $0) printf "Line %d differs: expected \"%s\", found \"%s\"\n", FNR, a[FNR], $0}' $expected_output actual_output.txt)

# If there are no differences, output_matches will be empty
if [ -z "$output_matches" ]; then
    echo "All pass"
else
    echo "Output differs:"
    echo "$output_matches"
fi

# Clean up
rm program.out actual_output.txt