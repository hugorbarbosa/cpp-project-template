#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable code static analysis, using clang-tidy.
#
# Parameters:
#
# - directories: Directories to get the files to be analyzed.
# - log_file: Log file to be created with the clang-tidy output.
function(enable_clang_tidy directories log_file)
    message(CHECK_START "Enabling code static analysis with clang-tidy")

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
        foreach(dir IN LISTS directories)
            if(EXISTS ${dir})
                # Search recursively the files.
                file(GLOB_RECURSE dir_files "${dir}/*.cpp" "${dir}/*.c")
                list(APPEND files ${dir_files})
            else()
                message(WARNING "Directory ${dir} does not exist")
            endif()
        endforeach()

        # Generated files.
        set(report_file "${CMAKE_BINARY_DIR}/${log_file}")

        if(files)
            add_custom_target(
                clang_tidy
                COMMENT "Run code static analysis using clang-tidy"
                COMMAND ${CMAKE_COMMAND} -E echo "Listing clang-tidy checks"
                COMMAND ${clang_tidy_path} --list-checks
                COMMAND ${CMAKE_COMMAND} -E echo "Running clang-tidy"
                COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
                COMMAND ${clang_tidy_path} -p ${CMAKE_BINARY_DIR} ${files} > ${report_file} 2>&1
                BYPRODUCTS ${report_file}
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                VERBATIM
            )
        else()
            message(WARNING "No files found in the provided directories for clang-tidy")
        endif()
    else()
        message(FATAL_ERROR "Clang-tidy analysis requires the clang compiler, not available for
                ${CMAKE_CXX_COMPILER_ID}"
        )
    endif()

    message(CHECK_PASS "done")
endfunction()
