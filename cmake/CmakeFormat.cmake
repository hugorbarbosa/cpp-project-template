#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add targets for CMake code formatting using cmake-format.
#
# The following targets are created:
#
# - A target that just checks the files without modifying them.
# - A target that formats the files.
#
# Usage:
# ~~~
#   add_cmake_format(
#       DIRECTORIES <dir1> [<dir2> ...]
#       [EXTRA_FILES <file1> [<file2> ...]]
#       [CONFIG_FILE <file>]
#       [LOG_FILE <file>]
#   )
# ~~~
#
# Arguments:
#
# - DIRECTORIES: List of directories to get the files to be analyzed.
# - EXTRA_FILES: Optional list of extra files to be analyzed.
# - CONFIG_FILE: Optional cmake-format configuration file to be used. If not provided, it is used
#   the default cmake-format configuration file discovery mechanism.
# - LOG_FILE: Optional log file path to be created with the cmake-format output. If not provided,
#   the default value is "${CMAKE_BINARY_DIR}/cmake_format_report.log".
function(add_cmake_format)
    message(CHECK_START "Adding targets for CMake code formatting using cmake-format")

    set(options)
    set(one_value_args LOG_FILE CONFIG_FILE)
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
    find_program(cmake_format_executable cmake-format REQUIRED)
    execute_process(
        COMMAND ${cmake_format_executable} --version
        OUTPUT_VARIABLE cmake_format_version
        ERROR_VARIABLE cmake_format_version
    )
    message(STATUS "cmake-format: ${cmake_format_version}")
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
        set(arg_LOG_FILE "${CMAKE_BINARY_DIR}/cmake_format_report.log")
        message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
    endif()

    # Configuration.
    set(config_file)
    if(arg_CONFIG_FILE)
        if(NOT EXISTS "${arg_CONFIG_FILE}")
            message(FATAL_ERROR "Configuration file does not exist: ${arg_CONFIG_FILE}")
        endif()
        set(config_file --config-files "${arg_CONFIG_FILE}")
        message(STATUS "Using cmake-format configuration file: ${arg_CONFIG_FILE}")
    else()
        message(STATUS "Using default cmake-format configuration file discovery mechanism")
    endif()

    if(files)
        add_custom_target(
            cmake_format_check
            COMMENT "Check CMake code formatting using cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
            COMMAND ${cmake_format_executable} ${config_file} --check ${files} > ${arg_LOG_FILE}
                    2>&1
            BYPRODUCTS ${arg_LOG_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        add_custom_target(
            cmake_format_apply
            COMMENT "Apply CMake code formatting using cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
            COMMAND ${cmake_format_executable} ${config_file} -i ${files} > ${arg_LOG_FILE} 2>&1
            BYPRODUCTS ${arg_LOG_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for cmake-format analysis")
    endif()

    message(CHECK_PASS "done")
endfunction()
