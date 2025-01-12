#!/usr/bin/env bash
#
# Compile the project with code coverage and generate report using LCOV.
# This scripts configures CMake and compiles the project with code coverage. The code coverage analysis results are
# created and can be accessed in "<build-dir>/coverage/index.html", where <build-dir> is the build directory name that
# can be configured by the user.
#
# Usage:
# $ ./<script>.sh [OPTIONS]
#
# Examples:
# - Run without specifying a build directory name ("build-coverage" name will be used):
# $ ./<script>.sh
# - Run specifying the build directory name as "build":
# $ ./<script>.sh -b build

set -o pipefail

# Log help message.
help() {
    echo "Compile the project with code coverage and generate report using LCOV"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo -e "\t-b, --build <directory>    build directory name (default is 'build-coverage')"
    echo -e "\t-j, --jobs <jobs>          maximum number of concurrent processes to use when building (default is 4)"
    echo -e "\t-h, --help                 display this help and exit"
}

# Log message.
#
# Parameters:
# $1: message to log.
log() {
    echo -e "$1"
}

# Log error message.
#
# Parameters:
# $1: message to log.
log_error() {
    readonly red_color='\033[0;31m'
    readonly no_color='\033[0m'
    echo -e "$red_color$1$no_color"
}

# Project directory
readonly project_dir=$(git rev-parse --show-toplevel)
# Build directory
build_dir=$project_dir/build-coverage
# Code coverage directory name
readonly coverage_dir=coverage
# Maximum number of concurrent processes
jobs=4
# Source directory name of the project
readonly src_dir=src

# Parse arguments (separated with spaces, e.g., --option argument)
while [ "$#" -gt 0 ]; do
    case $1 in
        -b|--build)
            build_dir=$project_dir/"$2"
            shift # past option
            shift # past argument
            ;;
        -j|--jobs)
            jobs="$2"
            shift # past option
            shift # past argument
            ;;
        -h|--help)
            help
            shift # past option
            exit 0
            ;;
        *)
            log_error "Unknown option $1"
            help
            exit 1
    esac
done

# Configure CMake and compile project with code coverage
log "Creating build directory: ${build_dir}"
cd $project_dir
mkdir -p $build_dir
cd $build_dir
log "Configuring CMake"
cmake .. -DCMAKE_BUILD_TYPE=Debug -DCPP_PROJECT_TEMPLATE_BUILD_COVERAGE=ON
log "Building project using $jobs jobs"
cmake --build . -j $jobs

# Run tests
log "Running tests"
ctest

# Directory for coverage results
if [ -d "$coverage_dir" ]; then
    # Delete previous results
    log "Deleting previous coverage results"
    rm -rf ./$coverage_dir/*
else
    # Create directory
    log "Creating directory for coverage results"
    mkdir -p $coverage_dir
fi

# Generate report
log "Generating coverage information"
lcov -c -d ./$src_dir -o coverage.info
log "Filtering coverage results"
lcov -r coverage.info */_deps/\* /usr/include/\* -o coverage_filtered.info
log "Generating coverage report"
genhtml coverage_filtered.info -o $coverage_dir

log "--------"
log "Code coverage report generated with success"
exit 0
