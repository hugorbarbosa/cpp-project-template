#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable CMake code formatting using cmake-format.
#
# The following targets are created: - A target that just checks the files without modifying them. -
# A target that formats the files.
#
# Parameters: DIRECTORIES: Directories to get the files. FILES: Specific files to be analyzed.
# LOG_FILE: Log file to be created with the cmake-format output.
function(enable_cmake_format DIRECTORIES FILES LOG_FILE)
    message(CHECK_START "Enabling CMake code formatting with cmake-format")

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(CMAKE_FORMAT_PATH cmake-format REQUIRED)
    execute_process(
        COMMAND ${CMAKE_FORMAT_PATH} --version
        OUTPUT_VARIABLE CMAKE_FORMAT_VERSION
        ERROR_VARIABLE CMAKE_FORMAT_VERSION
    )
    message(STATUS "cmake-format: ${CMAKE_FORMAT_VERSION}")
    message(CHECK_PASS "done")

    # Files to check.
    set(FILES_TO_CHECK)
    foreach(DIR IN LISTS DIRECTORIES)
        if(EXISTS ${DIR})
            # Search recursively the files.
            file(GLOB_RECURSE DIR_FILES "${DIR}/*.cmake" "${DIR}/CMakeLists.txt")
            list(APPEND FILES_TO_CHECK ${DIR_FILES})
        else()
            message(WARNING "Directory ${DIR} does not exist")
        endif()
    endforeach()
    list(APPEND FILES_TO_CHECK ${FILES})

    # Generated files.
    set(REPORT_FILE "${CMAKE_BINARY_DIR}/${LOG_FILE}")

    if(FILES_TO_CHECK)
        set(CMAKE_FORMAT_CHECK_TARGET "cmake_format_check")
        add_custom_target(
            ${CMAKE_FORMAT_CHECK_TARGET}
            COMMENT "Check CMake code formatting using cmake-format."
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${REPORT_FILE}"
            COMMAND ${CMAKE_FORMAT_PATH} --check ${FILES_TO_CHECK} > ${REPORT_FILE} 2>&1
            BYPRODUCTS ${REPORT_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )

        set(CMAKE_FORMAT_APPLY_TARGET "cmake_format_apply")
        add_custom_target(
            ${CMAKE_FORMAT_APPLY_TARGET}
            COMMENT "Apply CMake code formatting using cmake-format."
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-format"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${REPORT_FILE}"
            COMMAND ${CMAKE_FORMAT_PATH} -i ${FILES_TO_CHECK} > ${REPORT_FILE} 2>&1
            BYPRODUCTS ${REPORT_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for CMake code formatting")
    endif()

    message(CHECK_PASS "done")
endfunction()
