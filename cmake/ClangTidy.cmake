#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add a target for code static analysis using clang-tidy.
#
# Usage:
# ~~~
#   add_clang_tidy(
#       DIRECTORIES <dir1> [<dir2> ...]
#       [LOG_FILE <file>]
#   )
# ~~~
#
# Arguments:
#
# - DIRECTORIES: List of directories to get the files to be analyzed.
# - LOG_FILE: Optional log file path to be created with the clang-tidy output. If not provided, the
#   default value is "${CMAKE_BINARY_DIR}/clang_tidy_report.log".
function(add_clang_tidy)
    message(CHECK_START "Adding target for code static analysis using clang-tidy")

    set(options)
    set(one_value_args LOG_FILE)
    set(multi_value_args DIRECTORIES)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT arg_DIRECTORIES)
        message(FATAL_ERROR "At least one directory is required")
    endif()

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(clang_tidy_path clang-tidy REQUIRED)
    execute_process(
        COMMAND ${clang_tidy_path} --version
        OUTPUT_VARIABLE clang_tidy_version
        ERROR_VARIABLE clang_tidy_version
    )
    message(STATUS "Clang-tidy: ${clang_tidy_version}")
    message(CHECK_PASS "done")

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # Files to analyze.
        set(files)
        foreach(dir IN LISTS arg_DIRECTORIES)
            if(EXISTS ${dir})
                # Search recursively the files.
                file(GLOB_RECURSE dir_files "${dir}/*.cpp" "${dir}/*.c")
                list(APPEND files ${dir_files})
            else()
                message(WARNING "Directory ${dir} does not exist")
            endif()
        endforeach()

        # Log file.
        if(NOT arg_LOG_FILE)
            set(arg_LOG_FILE "${CMAKE_BINARY_DIR}/clang_tidy_report.log")
            message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
        endif()

        if(files)
            add_custom_target(
                clang_tidy
                COMMENT "Run code static analysis using clang-tidy"
                COMMAND ${CMAKE_COMMAND} -E echo "Listing clang-tidy checks"
                COMMAND ${clang_tidy_path} --list-checks
                COMMAND ${CMAKE_COMMAND} -E echo "Running clang-tidy"
                COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
                COMMAND ${clang_tidy_path} -p ${CMAKE_BINARY_DIR} ${files} > ${arg_LOG_FILE} 2>&1
                BYPRODUCTS ${arg_LOG_FILE}
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                VERBATIM
            )
        else()
            message(WARNING "No files found for clang-tidy analysis")
        endif()
    else()
        message(FATAL_ERROR "Clang-tidy analysis requires the clang compiler, not available for
                ${CMAKE_CXX_COMPILER_ID}"
        )
    endif()

    message(CHECK_PASS "done")
endfunction()
