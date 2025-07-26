#!/usr/bin/env bash
#
# Check code coverage results.

set -eo pipefail

# Log help message.
help() {
    echo "Check code coverage results."
    echo
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo -e "\t-b, --bin <path>           LCOV binary to use (default: \"lcov\")"
    echo -e "\t-r, --report <file>        coverage report file (default: \"coverage.info\")"
    echo -e "\t-l, --minline <value>      minimum lines coverage (default: 90%)"
    echo -e "\t-f, --minfunction <value>  minimum functions coverage (default: 80%)"
    echo -e "\t-h, --help                 display this message and exit"
}

# Log information message.
#
# Parameters:
#   $1: Message to log.
log() {
    echo -e "$1"
}

# Log error message.
#
# Parameters:
#   $1: Message to log.
log_error() {
    red_color='\033[0;31m'
    no_color='\033[0m'
    echo -e "$red_color$1$no_color"
}

lcov_binary="lcov"
report_file="coverage.info"
min_line_coverage=90
min_function_coverage=80

# Parse arguments (separated with spaces, e.g., --option argument).
while [ "$#" -gt 0 ]; do
    case $1 in
        -b|--bin)
            lcov_binary="$2"
            shift 2
            ;;
        -r|--report)
            report_file="$2"
            shift 2
            ;;
        -l|--minline)
            min_line_coverage="$2"
            shift 2
            ;;
        -f|--minfunction)
            min_function_coverage="$2"
            shift 2
            ;;
        -h|--help)
            help
            shift
            exit 0
            ;;
        *)
            log_error "Unknown option $1"
            help
            exit 1
    esac
done

log "LCOV binary path: ${lcov_binary}"
log "Coverage report file to be checked: ${report_file}"

log "Extracting the lines coverage from the file: ${report_file}"
line_coverage=$($lcov_binary --summary ${report_file} \
    | grep -E "lines" | awk '{print $2}' | sed 's/%.*//;s/\..*//')
log "Extracted lines coverage value: ${line_coverage}%"

log "Extracting the functions coverage from the file: ${report_file}"
function_coverage=$($lcov_binary --summary ${report_file} \
    | grep -E "functions" | awk '{print $2}' | sed 's/%.*//;s/\..*//')
log "Extracted functions coverage value: ${function_coverage}%"

error_code=0

log "Minimum lines coverage value: ${min_line_coverage}%"
log "Minimum functions coverage value: ${min_function_coverage}%"

if [ "$line_coverage" -ge "$min_line_coverage" ]; then
    log "Lines coverage is sufficient: ${line_coverage}%"
else
    log_error "Line coverage is insufficient: ${line_coverage}%"
    error_code=1
fi

if [ "$function_coverage" -ge "$min_function_coverage" ]; then
    log "Functions coverage is sufficient: ${function_coverage}%"
else
    log_error "Functions coverage is insufficient: ${function_coverage}%"
    error_code=1
fi

exit $error_code
