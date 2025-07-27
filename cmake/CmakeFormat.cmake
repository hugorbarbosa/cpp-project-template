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
# Parameters:
#
# - directories: Directories to get the files.
# - files: Specific files to be analyzed.
# - log_file: Log file to be created with the cmake-format output.
function(enable_cmake_format directories files log_file)
    message(CHECK_START "Enabling CMake code formatting with cmake-format")

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
    foreach(dir IN LISTS directories)
        if(EXISTS ${dir})
            # Search recursively the files.
            file(GLOB_RECURSE dir_files "${dir}/*.cmake" "${dir}/CMakeLists.txt")
            list(APPEND files_to_check ${dir_files})
        else()
            message(WARNING "Directory ${dir} does not exist")
        endif()
    endforeach()
    list(APPEND files_to_check ${files})

    # Generated files.
    set(report_file "${CMAKE_BINARY_DIR}/${log_file}")

    if(files_to_check)
        add_custom_target(
            cmake_format_check
            COMMENT "Check CMake code formatting using cmake-format."
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
            COMMAND ${cmake_format_path} --check ${files_to_check} > ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        add_custom_target(
            cmake_format_apply
            COMMENT "Apply CMake code formatting using cmake-format."
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
            COMMAND ${cmake_format_path} -i ${files_to_check} > ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for CMake code formatting")
    endif()

    message(CHECK_PASS "done")
endfunction()
