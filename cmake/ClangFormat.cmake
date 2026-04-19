#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable code formatting using clang-format.
#
# The following targets are created:
#
# - A target that just checks the files without modifying them.
# - A target that formats the files.
#
# Usage:
# ~~~
#   enable_clang_format(
#       DIRECTORIES <dir1> [<dir2> ...]
#       [LOG_FILE <file>]
#   )
# ~~~
#
# Arguments:
#
# - DIRECTORIES: List of directories to get the files to be analyzed. To make clang-format ignore
#   certain files, .clang-format-ignore files can be created. If not present, all the available
#   files (headers and C/C++ files) in these directories will be analyzed.
# - LOG_FILE: Optional log file to be created with the clang-format output. This file is created in
#   the CMAKE_BINARY_DIR. If not provided, the default value is "clang-format-report.log".
function(enable_clang_format)
    message(CHECK_START "Enabling code formatting with clang-format")

    set(options)
    set(oneValueArgs LOG_FILE)
    set(multiValueArgs DIRECTORIES)

    cmake_parse_arguments(arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT arg_DIRECTORIES)
        message(FATAL_ERROR "At least one directory is required")
    endif()

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(clang_format_path clang-format REQUIRED)
    execute_process(
        COMMAND ${clang_format_path} --version
        OUTPUT_VARIABLE clang_format_version
        ERROR_VARIABLE clang_format_version
    )
    message(STATUS "Clang-format: ${clang_format_version}")
    message(CHECK_PASS "done")

    # Files to check.
    set(files)
    foreach(dir IN LISTS arg_DIRECTORIES)
        if(EXISTS ${dir})
            # Search recursively the files.
            file(
                GLOB_RECURSE
                dir_files
                "${dir}/*.h"
                "${dir}/*.hpp"
                "${dir}/*.ipp"
                "${dir}/*.cpp"
                "${dir}/*.c"
            )
            list(APPEND files ${dir_files})
        else()
            message(WARNING "Directory ${dir} does not exist")
        endif()
    endforeach()

    # Log file.
    if(NOT arg_LOG_FILE)
        set(arg_LOG_FILE "clang-format-report.log")
        message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
    endif()
    set(report_file "${CMAKE_BINARY_DIR}/${arg_LOG_FILE}")

    if(files)
        add_custom_target(
            clang_format_check
            COMMENT "Check code formatting using clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report will be saved in: ${report_file}"
            COMMAND ${clang_format_path} --verbose --dry-run -Werror --style=file ${files} >
                    ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        add_custom_target(
            clang_format_apply
            COMMENT "Apply code formatting using clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report will be saved in: ${report_file}"
            COMMAND ${clang_format_path} --verbose --style=file -i ${files} > ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for clang-format analysis")
    endif()

    message(CHECK_PASS "done")
endfunction()
