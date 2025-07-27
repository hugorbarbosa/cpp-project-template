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
# Parameters:
#
# - directories: Directories to get the files. To make clang-format ignore certain files,
#   .clang-format-ignore files can be created. If not present, all the available files (headers and
#   C/C++ files) in these directories will be analyzed.
# - log_file: Log file to be created with the clang-format output.
function(enable_clang_format directories log_file)
    message(CHECK_START "Enabling code formatting with clang-format")

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
    foreach(dir IN LISTS directories)
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

    # Generated files.
    set(report_file "${CMAKE_BINARY_DIR}/${log_file}")

    if(files)
        add_custom_target(
            clang_format_check
            COMMENT "Check code formatting using clang-format."
            COMMAND ${CMAKE_COMMAND} -E echo "Running clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
            COMMAND ${clang_format_path} --verbose --dry-run -Werror --style=file ${files} >
                    ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        add_custom_target(
            clang_format_apply
            COMMENT "Apply code formatting using clang-format."
            COMMAND ${CMAKE_COMMAND} -E echo "Running clang-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
            COMMAND ${clang_format_path} --verbose --style=file -i ${files} > ${report_file} 2>&1
            BYPRODUCTS ${report_file}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for code formatting")
    endif()

    message(CHECK_PASS "done")
endfunction()
