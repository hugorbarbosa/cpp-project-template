#!/usr/bin/env bash
#
# Check code coverage results.

set -euo pipefail

# ----------------------------------------------------------------------------
# Global variables
# ----------------------------------------------------------------------------

LCOV_BIN="lcov"
REPORT_FILE="coverage.info"
MIN_LINE_COVERAGE=90
MIN_FUNCTION_COVERAGE=80

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

# Display usage information.
help() {
    cat <<EOF
Check code coverage results.

Usage: $0 [OPTIONS]

Options:
    -b, --bin <path>           LCOV binary (default: lcov)
    -r, --report <file>        coverage report (default: coverage.info)
    -l, --minline <value>      minimum line coverage, in percentage (default: 90)
    -f, --minfunction <value>  minimum function coverage, in percentage (default: 80)
    -h, --help                 display this message and exit
EOF
}

# Log an information message.
#
# Arguments:
# - $*: Message to log.
log() {
    printf "%s\n" "$*"
}

# Log an error message.
#
# Arguments:
# - $*: Message to log.
log_error() {
    printf "\033[0;31m%s\033[0m\n" "$*" >&2
}

# Parse command-line arguments (separated with spaces, e.g., --option argument).
#
# Arguments:
# - $@: Arguments to be parsed.
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b|--bin)
                LCOV_BIN="$2"
                shift 2
                ;;
            -r|--report)
                REPORT_FILE="$2"
                shift 2
                ;;
            -l|--minline)
                MIN_LINE_COVERAGE="$2"
                shift 2
                ;;
            -f|--minfunction)
                MIN_FUNCTION_COVERAGE="$2"
                shift 2
                ;;
            -h|--help)
                help
                exit 0
                ;;
            *)
                log_error "Unknown option $1"
                help
                exit 1
                ;;
        esac
    done
}

# Check required tools and inputs.
check_dependencies() {
    if ! command -v "$LCOV_BIN" >/dev/null 2>&1; then
        log_error "LCOV not found: $LCOV_BIN"
        exit 1
    fi

    if [[ ! -f "$REPORT_FILE" ]]; then
        log_error "Report file not found: $REPORT_FILE"
        exit 1
    fi
}

# Extract coverage metrics from coverage report.
#
# Sets:
# - LINE_COV: Extracted line coverage value.
# - FUNC_COV: Extracted function coverage value.
#
# Notes:
# - Values are truncated to integers.
extract_coverage() {
    local summary
    summary="$("$LCOV_BIN" --summary "$REPORT_FILE")"

    LINE_COV=$(awk '/lines/ {gsub(/%/,"",$2); print int($2)}' <<< "$summary")
    FUNC_COV=$(awk '/functions/ {gsub(/%/,"",$2); print int($2)}' <<< "$summary")
}

# Check extracted coverage values against configured thresholds.
#
# Returns:
# - 0 if all thresholds are met, 1 otherwise.
check_thresholds() {
    log "Line coverage: ${LINE_COV}% (min: ${MIN_LINE_COVERAGE}%)"
    if [ "$LINE_COV" -lt "$MIN_LINE_COVERAGE" ]; then
        log_error "Line coverage too low"
        return 1
    fi

    log "Function coverage: ${FUNC_COV}% (min: ${MIN_FUNCTION_COVERAGE}%)"
    if [ "$FUNC_COV" -lt "$MIN_FUNCTION_COVERAGE" ]; then
        log_error "Function coverage too low"
        return 1
    fi

    return 0
}

# Main function.
#
# Arguments:
# - $@: Command-line arguments.
main() {
    parse_args "$@"

    log "Using LCOV: $LCOV_BIN"
    log "Coverage report: $REPORT_FILE"

    check_dependencies
    extract_coverage

    log "Extracted line coverage: ${LINE_COV}%"
    log "Extracted function coverage: ${FUNC_COV}%"

    if ! check_thresholds; then
        exit 1
    fi

    exit 0
}

# ----------------------------------------------------------------------------
# Program
# ----------------------------------------------------------------------------

main "$@"
