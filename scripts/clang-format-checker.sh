#!/usr/bin/env bash
#
# Check code formatting using clang-format.

set -eo pipefail

# Log help message.
help() {
    echo "Check code formatting using clang-format."
    echo
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo -e "\t-d, --dir <directory>    directory to check (default: git project files)"
    echo -e "\t-b, --build <directory>  build directory (default: \"build-clang-format\")"
    echo -e "\t-m, --max <errors>       maximum errors accepted (default: 0)"
    echo -e "\t-h, --help               display this message and exit"
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

readonly project_dir=$(git rev-parse --show-toplevel)
build_dir=$project_dir/build-clang-format
max_errors=0

# Parse arguments (separated with spaces, e.g., --option argument).
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--dir)
            dir_check="$2"
            shift 2
            ;;
        -b|--build)
            build_dir="$2"
            shift 2
            ;;
        -m|--max)
            max_errors="$2"
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

log "Creating build directory: ${build_dir}"
cd $project_dir
mkdir -p $build_dir

set +e

log "Getting files to check"
if [ -z ${dir_check+x} ]; then
    log "Directory not provided, getting files using git"
    files=$(git ls-files | grep -i -e "\.h$" -e "\.hpp$" -e "\.ipp$" -e "\.cpp$" -e "\.c$")
else
    log "Getting files in the directory: ${dir_check}"
    files=$(find $dir_check -type f -iname "*.h" -o -iname "*.hpp" -o -iname "*.ipp" \
        -o -iname "*.cpp" -o -iname "*.c")
fi

if [[ -z "$files" ]]; then
    log_error "No files to check"
    exit 1
fi

readonly report_file=$build_dir/report.txt
log "Running clang-format"
clang-format $files --verbose --dry-run -Werror --style=file 2>&1 | tee $report_file

readonly errors_count=$(grep -o -i ".*error: .*$" $report_file | wc -l)

log "--------"
log "Number of errors: $errors_count"
log "Maximum number of errors accepted: $max_errors"
log "For more details, check the file: ${report_file}"

if [ "$errors_count" -gt "$max_errors" ]; then
    log_error "Result: FAILED"
    exit 1
fi

log "Result: PASSED"
exit 0
