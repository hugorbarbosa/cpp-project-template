#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable CMake lint using cmake-lint.

# Usage:
# ~~~
#   enable_cmake_lint(
#       DIRECTORIES <dir1> [<dir2> ...]
#       [EXTRA_FILES <file1> [<file2> ...]]
#       [LOG_FILE <file>]
#   )
# ~~~
#
# Arguments:
#
# - DIRECTORIES: List of directories to get the files to be analyzed.
# - EXTRA_FILES: Optional list of extra files to be analyzed.
# - LOG_FILE: Optional log file path to be created with the cmake-lint output. If not provided, the
# default value is "${CMAKE_BINARY_DIR}/cmake_lint_report.log".
function(enable_cmake_lint)
    message(CHECK_START "Enabling CMake lint with cmake-lint")

    set(options)
    set(one_value_args LOG_FILE)
    set(multi_value_args DIRECTORIES EXTRA_FILES)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT arg_DIRECTORIES)
        message(FATAL_ERROR "At least one directory is required")
    endif()

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(cmake_lint_path cmake-lint REQUIRED)
    execute_process(
        COMMAND ${cmake_lint_path} --version
        OUTPUT_VARIABLE cmake_lint_version
        ERROR_VARIABLE cmake_lint_version
    )
    message(STATUS "cmake-lint: ${cmake_lint_version}")
    message(CHECK_PASS "done")

    # Files to check.
    set(files)
    foreach(dir IN LISTS arg_DIRECTORIES)
        if(EXISTS ${dir})
            # Search recursively the files.
            file(GLOB_RECURSE dir_files "${dir}/*.cmake" "${dir}/CMakeLists.txt")
            list(APPEND files ${dir_files})
        else()
            message(WARNING "Directory ${dir} does not exist")
        endif()
    endforeach()
    list(APPEND files ${arg_EXTRA_FILES})

    # Log file.
    if(NOT arg_LOG_FILE)
        set(arg_LOG_FILE "${CMAKE_BINARY_DIR}/cmake_lint_report.log")
        message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
    endif()

    if(files)
        add_custom_target(
            cmake_lint
            COMMENT "Check CMake code using cmake-lint"
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-lint"
            COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
            COMMAND ${cmake_lint_path} ${files} -o ${arg_LOG_FILE} 2>&1
            BYPRODUCTS ${arg_LOG_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for cmake-lint analysis")
    endif()

    message(CHECK_PASS "done")
endfunction()
