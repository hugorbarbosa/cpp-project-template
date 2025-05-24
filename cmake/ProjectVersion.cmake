#
# Copyright (C) 2025 Hugo Barbosa.
#

# Parse project version from the provided header file.
#
# Parameters:
#   HEADER_FILE: Header file that contains the project version to be parsed.
function(parse_project_version HEADER_FILE)
    message(CHECK_START "Parsing project version from header file ${HEADER_FILE}")

    if(NOT EXISTS "${HEADER_FILE}")
        message(FATAL_ERROR "Header file not found: ${HEADER_FILE}")
    endif()

    file(READ "${HEADER_FILE}" FILE_CONTENT)

    # Major version.
    string(REGEX MATCH "project_version_major = ([0-9]+)" _ ${FILE_CONTENT})
    if(NOT CMAKE_MATCH_1)
        message(FATAL_ERROR "Major version definition not found in ${HEADER_FILE}")
    endif()
    set(MAJOR_VERSION ${CMAKE_MATCH_1})

    # Minor version.
    string(REGEX MATCH "project_version_minor = ([0-9]+)" _ ${FILE_CONTENT})
    if(NOT CMAKE_MATCH_1)
        message(FATAL_ERROR "Minor version definition not found in ${HEADER_FILE}")
    endif()
    set(MINOR_VERSION ${CMAKE_MATCH_1})

    # Patch version.
    string(REGEX MATCH "project_version_patch = ([0-9]+)" _ ${FILE_CONTENT})
    if(NOT CMAKE_MATCH_1)
        message(FATAL_ERROR "Patch version definition not found in ${HEADER_FILE}")
    endif()
    set(PATCH_VERSION ${CMAKE_MATCH_1})

    # Optional pre-release tag (string literal).
    string(REGEX MATCH "project_version_prerelease = \"([^\"]*)\"" _ ${FILE_CONTENT})
    if(CMAKE_MATCH_1)
        set(PRERELEASE_VERSION ${CMAKE_MATCH_1})
    endif()

    # Version without prerelease.
   set(BASE_VERSION "${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}")

    # Version with prerelease if exists.
    set(FULL_VERSION ${BASE_VERSION})
    if(PRERELEASE_VERSION)
        set(FULL_VERSION "${BASE_VERSION}-${PRERELEASE_VERSION}")
    endif()

    # Variables to be used in the parent scope.
    set(PROJECT_VERSION_BASE ${BASE_VERSION} PARENT_SCOPE)
    set(PROJECT_VERSION_FULL ${FULL_VERSION} PARENT_SCOPE)

    message(CHECK_PASS "done")
endfunction()
