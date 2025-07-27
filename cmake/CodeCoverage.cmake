#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add the compiler options for code coverage to the provided target.
#
# Parameters:
#
# - target_name: Name of the target to add coverage compiler options.
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
# Parameters:
#
# - target_name: Name of the target to add coverage compiler options.
# - exclude_patterns: Patterns to be excluded from the coverage analysis.
# - min_line_coverage: Minimum lines coverage value to succeed.
# - min_function_coverage: Minimum functions coverage value to succeed.
# - cov_check_script: Coverage report checker script path.
function(enable_coverage target_name exclude_patterns min_line_coverage min_function_coverage
         cov_check_script
)
    message(CHECK_START "Enabling code coverage for target ${target_name}")

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Code coverage in a non-Debug build may be misleading")
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
    foreach(pattern IN LISTS exclude_patterns)
        message(STATUS "Excluding pattern: ${pattern}")
        list(APPEND lcov_excludes "${pattern}")
    endforeach()
    list(REMOVE_DUPLICATES lcov_excludes)

    # LCOV base directory.
    set(lcov_base_dir ${PROJECT_SOURCE_DIR})

    # Generated files.
    set(coverage_target "coverage")
    set(base_file "${coverage_target}-base.info")
    set(capture_file "${coverage_target}-capture.info")
    set(total_file "${coverage_target}-total.info")
    set(filtered_file "${coverage_target}-filtered.info")
    set(report_dir "${coverage_target}")
    set(report_file "${coverage_target}/index.html")

    set(jobs 4)
    add_custom_target(
        ${coverage_target}
        COMMENT "Run code coverage analysis"
        COMMAND ${CMAKE_COMMAND} -E echo "Cleaning coverage data"
        COMMAND ${lcov_path} --directory . -b ${lcov_base_dir} --zerocounters
        COMMAND ${CMAKE_COMMAND} -E echo "Building project using ${jobs} jobs"
        COMMAND ${CMAKE_COMMAND} --build . -j ${jobs}
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
        COMMAND ${genhtml_path} ${filtered_file} --output-directory ${report_dir} --legend
                --show-details
        COMMAND ${CMAKE_COMMAND} -E echo "Coverage report: ${CMAKE_BINARY_DIR}/${report_file}"
        COMMAND ${CMAKE_COMMAND} -E echo "Checking code coverage report:"
        COMMAND ${CMAKE_COMMAND} -E echo "- Minimum line coverage: ${min_line_coverage}"
        COMMAND ${CMAKE_COMMAND} -E echo "- Minimum function coverage: ${min_function_coverage}"
        COMMAND ${cov_check_script} -b ${lcov_path} -r ${filtered_file} -l ${min_line_coverage} -f
                ${min_function_coverage}
        BYPRODUCTS ${base_file} ${capture_file} ${total_file} ${filtered_file} ${report_file}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        VERBATIM
    )

    message(CHECK_PASS "done")
endfunction()
