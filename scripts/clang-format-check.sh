#!/usr/bin/env bash

# Check code format using clang-format.
#
# Usage:
# $ ./<script>.sh <directory>
#
# Example:
# - Check "src" directory:
# $ ./<script>.sh src
# - Check "tests" directory:
# $ ./<script>.sh tests

# Check script usage
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "$0 <directory>"
    echo
    exit -1
fi

# Directory to check
src_dir=$1

echo "Clang-format checking..."

# Find files and run clang-format
find $src_dir -type f -iname "*.h" -o -iname "*.cpp" | xargs clang-format --dry-run -Werror --style=file

# Command to reformat a file:
# clang-format -i --style=file <file>

echo "Clang-format check end"
