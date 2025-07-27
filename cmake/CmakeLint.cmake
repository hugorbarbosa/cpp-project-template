#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable CMake lint using cmake-lint.
#
# Parameters:
#
# - directories: Directories to get the files.
# - files: Specific files to be analyzed.
# - log_file: Log file to be created with the cmake-lint output.
function(enable_cmake_lint directories files log_file)
    message(CHECK_START "Enabling CMake lint with cmake-lint")

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
            cmake_lint
            COMMENT "Check CMake code using cmake-lint."
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-lint"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
            COMMAND ${cmake_lint_path} ${files_to_check} -o ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for CMake lint")
    endif()

    message(CHECK_PASS "done")
endfunction()
