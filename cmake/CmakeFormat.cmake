#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable CMake code formatting using cmake-format.
#
# The following targets are created:
#
# - A target that just checks the files without modifying them.
# - A target that formats the files.
#
# Usage:
# ~~~
#   enable_cmake_format(
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
# - LOG_FILE: Optional log file to be created with the cmake-format output. This file is created in
#   the CMAKE_BINARY_DIR. If not provided, the default value is "cmake-format-report.log".
function(enable_cmake_format)
    message(CHECK_START "Enabling CMake code formatting with cmake-format")

    set(options)
    set(oneValueArgs LOG_FILE)
    set(multiValueArgs DIRECTORIES EXTRA_FILES)

    cmake_parse_arguments(arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(NOT arg_DIRECTORIES)
        message(FATAL_ERROR "At least one directory is required")
    endif()

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(cmake_format_path cmake-format REQUIRED)
    execute_process(
        COMMAND ${cmake_format_path} --version
        OUTPUT_VARIABLE cmake_format_version
        ERROR_VARIABLE cmake_format_version
    )
    message(STATUS "cmake-format: ${cmake_format_version}")
    message(CHECK_PASS "done")

    # Files to check.
    set(files_to_check)
    foreach(dir IN LISTS arg_DIRECTORIES)
        if(EXISTS ${dir})
            # Search recursively the files.
            file(GLOB_RECURSE dir_files "${dir}/*.cmake" "${dir}/CMakeLists.txt")
            list(APPEND files_to_check ${dir_files})
        else()
            message(WARNING "Directory ${dir} does not exist")
        endif()
    endforeach()
    list(APPEND files_to_check ${arg_EXTRA_FILES})

    # Log file.
    if(NOT arg_LOG_FILE)
        set(arg_LOG_FILE "cmake-format-report.log")
        message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
    endif()
    set(report_file "${CMAKE_BINARY_DIR}/${arg_LOG_FILE}")

    if(files_to_check)
        add_custom_target(
            cmake_format_check
            COMMENT "Check CMake code formatting using cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report will be saved in: ${report_file}"
            COMMAND ${cmake_format_path} --check ${files_to_check} > ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        add_custom_target(
            cmake_format_apply
            COMMENT "Apply CMake code formatting using cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report will be saved in: ${report_file}"
            COMMAND ${cmake_format_path} -i ${files_to_check} > ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for cmake-format analysis")
    endif()

    message(CHECK_PASS "done")
endfunction()
