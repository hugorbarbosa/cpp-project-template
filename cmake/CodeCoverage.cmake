#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add the compiler options for code coverage to the provided target.
#
# Parameters: TARGET_NAME: Name of the target to add coverage compiler options.
function(add_coverage_compiler_options TARGET_NAME)
    set(GCC_COVERAGE_OPTIONS
        # Compile and link code instrumented for coverage analysis.
        --coverage
        # Produce debugging information.
        -g
        # Reduce compilation time and make debugging produce the expected results.
        -O0
        # Add code so that program flow arcs are instrumented.
        -fprofile-arcs
        # Produce a notes file that the gcov utility can use.
        -ftest-coverage
        # Convert file names to absolute path names in the .gcno files.
        -fprofile-abs-path
    )

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${TARGET_NAME} INTERFACE ${GCC_COVERAGE_OPTIONS})
        target_link_libraries(${TARGET_NAME} INTERFACE gcov)
        message(STATUS "Added coverage compiler options for target ${TARGET_NAME}")
    else()
        message(FATAL_ERROR "Coverage only for GCC, not available for ${CMAKE_CXX_COMPILER_ID}")
    endif()
endfunction()

# Enable code coverage for the provided target and create coverage target.
#
# Parameters: TARGET_NAME: Name of the target to add coverage compiler options. EXCLUDE_PATTERNS:
# Patterns to be excluded from the coverage analysis. MIN_LINE_COVERAGE: Minimum lines coverage
# value to succeed. MIN_FUNCTION_COVERAGE: Minimum functions coverage value to succeed. JOBS: Number
# of jobs for compilation. COV_CHECK_SCRIPT: Coverage report checker script path.
function(
    enable_coverage
    TARGET_NAME
    EXCLUDE_PATTERNS
    MIN_LINE_COVERAGE
    MIN_FUNCTION_COVERAGE
    JOBS
    COV_CHECK_SCRIPT
)
    message(CHECK_START "Enabling code coverage for target ${TARGET_NAME}")

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Code coverage in a non-Debug build may be misleading")
    endif()

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(GCOV_PATH gcov REQUIRED)
    find_program(LCOV_PATH lcov REQUIRED)
    execute_process(
        COMMAND ${LCOV_PATH} --version
        OUTPUT_VARIABLE LCOV_VERSION
        ERROR_VARIABLE LCOV_VERSION
    )
    message(STATUS "LCOV: ${LCOV_VERSION}")
    find_program(GENHTML_PATH genhtml REQUIRED)
    message(CHECK_PASS "done")

    # Compiler options.
    message(CHECK_START "Adding coverage compiler options")
    add_coverage_compiler_options(${TARGET_NAME})
    message(CHECK_PASS "done")

    # Excludes.
    set(LCOV_EXCLUDES "")
    foreach(PATTERN IN LISTS EXCLUDE_PATTERNS)
        message(STATUS "Excluding pattern: ${PATTERN}")
        list(APPEND LCOV_EXCLUDES "${PATTERN}")
    endforeach()
    list(REMOVE_DUPLICATES LCOV_EXCLUDES)

    # LCOV base directory.
    set(LCOV_BASE_DIR ${PROJECT_SOURCE_DIR})

    # Generated files.
    set(COVERAGE_TARGET_NAME "coverage")
    set(COVERAGE_BASE_FILE "${COVERAGE_TARGET_NAME}-base.info")
    set(COVERAGE_CAPTURE_FILE "${COVERAGE_TARGET_NAME}-capture.info")
    set(COVERAGE_TOTAL_FILE "${COVERAGE_TARGET_NAME}-total.info")
    set(COVERAGE_FILTERED_FILE "${COVERAGE_TARGET_NAME}-filtered.info")
    set(COVERAGE_REPORT_DIR "${COVERAGE_TARGET_NAME}")
    set(COVERAGE_REPORT_FILE "${COVERAGE_TARGET_NAME}/index.html")

    # List of commands. Build and test.
    set(BUILD_CMD ${CMAKE_COMMAND} --build . -j ${JOBS})
    set(TEST_CMD ${CMAKE_CTEST_COMMAND} --output-on-failure)
    # LCOV.
    set(LCOV_CLEAN_CMD ${LCOV_PATH} --directory . -b ${LCOV_BASE_DIR} --zerocounters)
    set(LCOV_BASELINE_CMD
        ${LCOV_PATH}
        --directory
        .
        -b
        ${LCOV_BASE_DIR}
        --capture
        --initial
        --output-file
        ${COVERAGE_BASE_FILE}
        --ignore-errors
        mismatch
        --ignore-errors
        unused
    )
    set(LCOV_CAPTURE_CMD
        ${LCOV_PATH}
        --directory
        .
        -b
        ${LCOV_BASE_DIR}
        --capture
        --output-file
        ${COVERAGE_CAPTURE_FILE}
        --ignore-errors
        mismatch
        --ignore-errors
        unused
    )
    set(LCOV_TOTAL_CMD
        ${LCOV_PATH}
        --add-tracefile
        ${COVERAGE_BASE_FILE}
        --add-tracefile
        ${COVERAGE_CAPTURE_FILE}
        --output-file
        ${COVERAGE_TOTAL_FILE}
    )
    set(LCOV_FILTER_CMD
        ${LCOV_PATH}
        --remove
        ${COVERAGE_TOTAL_FILE}
        ${LCOV_EXCLUDES}
        --output-file
        ${COVERAGE_FILTERED_FILE}
        --ignore-errors
        mismatch
        --ignore-errors
        unused
    )
    # HTML report.
    set(GENHTML_REPORT_CMD ${GENHTML_PATH} ${COVERAGE_FILTERED_FILE} --output-directory
                           ${COVERAGE_REPORT_DIR} --legend --show-details
    )
    # Coverage report checker.
    set(COV_CHECK_SCRIPT_CMD
        ${COV_CHECK_SCRIPT}
        -b
        ${LCOV_PATH}
        -r
        ${COVERAGE_FILTERED_FILE}
        -l
        ${MIN_LINE_COVERAGE}
        -f
        ${MIN_FUNCTION_COVERAGE}
    )

    # Target.
    add_custom_target(
        ${COVERAGE_TARGET_NAME}
        COMMENT "Run code coverage analysis."
        COMMAND ${CMAKE_COMMAND} -E echo "Cleaning coverage data"
        COMMAND ${LCOV_CLEAN_CMD}
        COMMAND ${CMAKE_COMMAND} -E echo "Building project using ${JOBS} jobs"
        COMMAND ${BUILD_CMD}
        COMMAND ${CMAKE_COMMAND} -E echo "Creating coverage baseline"
        COMMAND ${LCOV_BASELINE_CMD}
        COMMAND ${CMAKE_COMMAND} -E echo "Running tests"
        COMMAND ${TEST_CMD}
        COMMAND ${CMAKE_COMMAND} -E echo "Generating code coverage information"
        COMMAND ${LCOV_CAPTURE_CMD}
        COMMAND ${LCOV_TOTAL_CMD}
        COMMAND ${LCOV_FILTER_CMD}
        COMMAND ${CMAKE_COMMAND} -E echo "Generating HTML code coverage report"
        COMMAND ${GENHTML_REPORT_CMD}
        COMMAND ${CMAKE_COMMAND} -E echo
                "Coverage report: ${CMAKE_BINARY_DIR}/${COVERAGE_REPORT_FILE}"
        COMMAND ${CMAKE_COMMAND} -E echo "Checking code coverage report:"
        COMMAND ${CMAKE_COMMAND} -E echo "- Minimum line coverage: ${MIN_LINE_COVERAGE}"
        COMMAND ${CMAKE_COMMAND} -E echo "- Minimum function coverage: ${MIN_FUNCTION_COVERAGE}"
        COMMAND ${COV_CHECK_SCRIPT_CMD}
        BYPRODUCTS ${COVERAGE_BASE_FILE} ${COVERAGE_CAPTURE_FILE} ${COVERAGE_TOTAL_FILE}
                   ${COVERAGE_FILTERED_FILE} ${COVERAGE_REPORT_FILE}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        VERBATIM
    )

    message(CHECK_PASS "done")
endfunction()
