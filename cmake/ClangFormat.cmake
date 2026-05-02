#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add targets for code formatting using clang-format.
#
# The following targets are created:
#
# - A target that just checks the files without modifying them.
# - A target that formats the files.
#
# Usage:
# ~~~
#   add_clang_format(
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
# - LOG_FILE: Optional log file path to be created with the clang-format output. If not provided,
#   the default value is "${CMAKE_BINARY_DIR}/clang_format_report.log".
function(add_clang_format)
    message(CHECK_START "Adding targets for code formatting using clang-format")

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
    find_program(clang_format_executable clang-format REQUIRED)
    execute_process(
        COMMAND ${clang_format_executable} --version
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
        set(arg_LOG_FILE "${CMAKE_BINARY_DIR}/clang_format_report.log")
        message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
    endif()

    if(files)
        add_custom_target(
            clang_format_check
            COMMENT "Check code formatting using clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
            COMMAND ${clang_format_executable} --verbose --dry-run -Werror --style=file ${files} >
                    ${arg_LOG_FILE} 2>&1
            BYPRODUCTS ${arg_LOG_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        add_custom_target(
            clang_format_apply
            COMMENT "Apply code formatting using clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
            COMMAND ${clang_format_executable} --verbose --style=file -i ${files} > ${arg_LOG_FILE}
                    2>&1
            BYPRODUCTS ${arg_LOG_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for clang-format analysis")
    endif()

    message(CHECK_PASS "done")
endfunction()
