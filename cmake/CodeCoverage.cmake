#
# Copyright (C) 2025 Hugo Barbosa.
#

set(CODE_COVERAGE_DIR "${CMAKE_CURRENT_LIST_DIR}")

# Add the compiler options for code coverage to the provided target.
#
# Usage:
# ~~~
#   add_coverage_compiler_options(<target>)
# ~~~
function(add_coverage_compiler_options target_name)
    set(gcc_coverage_options
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
        target_compile_options(${target_name} INTERFACE ${gcc_coverage_options})
        target_link_libraries(${target_name} INTERFACE gcov)
        message(STATUS "Added coverage compiler options for target ${target_name}")
    else()
        message(FATAL_ERROR "Coverage only for GCC, not available for ${CMAKE_CXX_COMPILER_ID}")
    endif()
endfunction()

# Enable code coverage for the provided target and create coverage target.
#
# Usage:
# ~~~
#   enable_coverage(<target>
#       [EXCLUDE_PATTERNS <pattern1> [<pattern2> ...]]
#       [MIN_LINE_COVERAGE <value>]
#       [MIN_FUNCTION_COVERAGE <value>]
#       [REPORT_DIR <dir>]
#       [PARALLEL <jobs>]
#   )
# ~~~
#
# Arguments:
#
# - EXCLUDE_PATTERNS: Optional list of patterns to be excluded from the coverage analysis.
# - MIN_LINE_COVERAGE: Optional minimum lines coverage value to succeed, in percentage. If not
#   provided, the default value is 90.
# - MIN_FUNCTION_COVERAGE: Optional minimum functions coverage value to succeed, in percentage. If
#   not provided, the default value is 80.
# - REPORT_DIR: Optional report directory where the coverage analysis report will be created. If not
#   provided, the default value is "${CMAKE_BINARY_DIR}/coverage".
# - PARALLEL: Optional maximum number of concurrent processes to use when building. If not provided,
#   the default value is 8.
function(enable_coverage target_name)
    message(CHECK_START "Enabling code coverage for target ${target_name}")

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Code coverage in a non-Debug build may be misleading")
    endif()

    set(options)
    set(one_value_args MIN_LINE_COVERAGE MIN_FUNCTION_COVERAGE REPORT_DIR PARALLEL)
    set(multi_value_args EXCLUDE_PATTERNS)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(gcov_path gcov REQUIRED)
    find_program(lcov_path lcov REQUIRED)
    execute_process(
        COMMAND ${lcov_path} --version
        OUTPUT_VARIABLE lcov_version
        ERROR_VARIABLE lcov_version
    )
    message(STATUS "LCOV: ${lcov_version}")
    find_program(genhtml_path genhtml REQUIRED)
    message(CHECK_PASS "done")

    # Compiler options.
    message(CHECK_START "Adding coverage compiler options")
    add_coverage_compiler_options(${target_name})
    message(CHECK_PASS "done")

    # Excludes.
    set(lcov_excludes "")
    foreach(pattern IN LISTS arg_EXCLUDE_PATTERNS)
        message(STATUS "Excluding pattern: ${pattern}")
        list(APPEND lcov_excludes "${pattern}")
    endforeach()
    list(REMOVE_DUPLICATES lcov_excludes)

    # Minimum coverage values.
    if(NOT arg_MIN_LINE_COVERAGE)
        set(arg_MIN_LINE_COVERAGE 90)
        message(STATUS "Min line coverage not provided. Using: ${arg_MIN_LINE_COVERAGE}%")
    endif()
    if(NOT arg_MIN_FUNCTION_COVERAGE)
        set(arg_MIN_FUNCTION_COVERAGE 80)
        message(STATUS "Min function coverage not provided. Using: ${arg_MIN_FUNCTION_COVERAGE}%")
    endif()

    # Report directory.
    if(NOT arg_REPORT_DIR)
        set(arg_REPORT_DIR "${CMAKE_BINARY_DIR}/coverage")
        message(STATUS "Report directory not provided. Using default value: ${arg_REPORT_DIR}")
    endif()

    # Parallel processes.
    if(NOT arg_PARALLEL)
        set(arg_PARALLEL 8)
        message(
            STATUS
                "Number of concurrent processes not provided. Using default value: ${arg_PARALLEL}"
        )
    endif()

    # LCOV base directory.
    set(lcov_base_dir ${PROJECT_SOURCE_DIR})

    # Generated files.
    set(coverage_target "coverage")
    set(base_file "${coverage_target}_base.info")
    set(capture_file "${coverage_target}_capture.info")
    set(total_file "${coverage_target}_total.info")
    set(filtered_file "${coverage_target}_filtered.info")
    set(report_file "${arg_REPORT_DIR}/index.html")

    # Helper script.
    set(coverage_check_script "${CODE_COVERAGE_DIR}/code_coverage/code_coverage_checker.sh")

    add_custom_target(
        ${coverage_target}
        COMMENT "Run code coverage analysis"
        COMMAND ${CMAKE_COMMAND} -E echo "Running code coverage analysis"
        COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${report_file}"
        COMMAND ${CMAKE_COMMAND} -E echo "Cleaning coverage data"
        COMMAND ${lcov_path} --directory . -b ${lcov_base_dir} --zerocounters
        COMMAND ${CMAKE_COMMAND} -E echo "Building project using ${arg_PARALLEL} jobs"
        COMMAND ${CMAKE_COMMAND} --build . -j ${arg_PARALLEL}
        COMMAND ${CMAKE_COMMAND} -E echo "Creating coverage baseline"
        COMMAND ${lcov_path} --directory . -b ${lcov_base_dir} --capture --initial --output-file
                ${base_file} --ignore-errors mismatch --ignore-errors unused
        COMMAND ${CMAKE_COMMAND} -E echo "Running tests"
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
        COMMAND ${CMAKE_COMMAND} -E echo "Generating code coverage information"
        COMMAND ${lcov_path} --directory . -b ${lcov_base_dir} --capture --output-file
                ${capture_file} --ignore-errors mismatch --ignore-errors unused
        COMMAND ${lcov_path} --add-tracefile ${base_file} --add-tracefile ${capture_file}
                --output-file ${total_file}
        COMMAND ${lcov_path} --remove ${total_file} ${lcov_excludes} --output-file ${filtered_file}
                --ignore-errors mismatch --ignore-errors unused
        COMMAND ${CMAKE_COMMAND} -E echo "Generating HTML code coverage report"
        COMMAND ${genhtml_path} ${filtered_file} --output-directory ${arg_REPORT_DIR} --legend
                --show-details
        COMMAND ${CMAKE_COMMAND} -E echo "Checking code coverage report:"
        COMMAND ${CMAKE_COMMAND} -E echo "- Minimum line coverage: ${arg_MIN_LINE_COVERAGE}"
        COMMAND ${CMAKE_COMMAND} -E echo "- Minimum function coverage: ${arg_MIN_FUNCTION_COVERAGE}"
        COMMAND ${coverage_check_script} -b ${lcov_path} -r ${filtered_file} -l
                ${arg_MIN_LINE_COVERAGE} -f ${arg_MIN_FUNCTION_COVERAGE}
        BYPRODUCTS ${base_file} ${capture_file} ${total_file} ${filtered_file} ${report_file}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        VERBATIM
    )

    message(CHECK_PASS "done")
endfunction()
