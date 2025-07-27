#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable CMake lint using cmake-lint.
#
# Parameters: * DIRECTORIES: Directories to get the files. * FILES: Specific files to be analyzed. *
# LOG_FILE: Log file to be created with the cmake-lint output.
function(enable_cmake_lint DIRECTORIES FILES LOG_FILE)
    message(CHECK_START "Enabling CMake lint with cmake-lint")

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(CMAKE_LINT_PATH cmake-lint REQUIRED)
    execute_process(
        COMMAND ${CMAKE_LINT_PATH} --version
        OUTPUT_VARIABLE CMAKE_LINT_VERSION
        ERROR_VARIABLE CMAKE_LINT_VERSION
    )
    message(STATUS "cmake-lint: ${CMAKE_LINT_VERSION}")
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
        set(CMAKE_LINT_TARGET "cmake_lint")
        add_custom_target(
            ${CMAKE_LINT_TARGET}
            COMMENT "Check CMake code using cmake-lint."
            COMMAND ${CMAKE_COMMAND} -E echo "Running cmake-lint"
            COMMAND ${CMAKE_COMMAND} -E echo "Report: ${REPORT_FILE}"
            COMMAND ${CMAKE_LINT_PATH} ${FILES_TO_CHECK} -o ${REPORT_FILE} 2>&1
            BYPRODUCTS ${REPORT_FILE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            VERBATIM
        )
    else()
        message(WARNING "No files found for CMake lint")
    endif()

    message(CHECK_PASS "done")
endfunction()
