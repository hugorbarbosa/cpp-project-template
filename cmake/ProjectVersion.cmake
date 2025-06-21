#
# Copyright (C) 2025 Hugo Barbosa.
#

# Extract version value from the provided version name and content.
#
# Parameters:
#   OUT_VAR: Output variable that will contain the extracted version.
#   VERSION_NAME: Version name (major, minor, etc).
#   CONTENT: Content from which the version should be extracted.
macro(extract_version OUT_VAR VERSION_NAME CONTENT)
    set(REGEX_PATTERN "${VERSION_NAME}[ \t]*=[ \t]*([0-9]+)")

    unset(CMAKE_MATCH_1)
    string(REGEX MATCH "${REGEX_PATTERN}" _ "${CONTENT}")
    if(NOT DEFINED CMAKE_MATCH_1)
        message(FATAL_ERROR "Version '${VERSION_NAME}' not found")
    endif()

    set(${OUT_VAR} "${CMAKE_MATCH_1}")
endmacro()

# Extract an optional version string from the provided version name and content.
#
# Parameters:
#   OUT_VAR: Output variable that will contain the extracted version.
#   VERSION_NAME: Version name (prerelease, etc).
#   CONTENT: Content from which the version should be extracted.
macro(extract_optional_version_str OUT_VAR VERSION_NAME CONTENT)
    # Match: key = "some string" or key = "".
    set(REGEX_PATTERN "${VERSION_NAME}[ \t]*=[ \t]*\"([^\"]*)\"")

    unset(CMAKE_MATCH_1)
    unset(MATCH_LINE)

    # Match the full line to ensure it exists.
    string(REGEX MATCH "${REGEX_PATTERN}" MATCH_LINE "${CONTENT}")
    if(MATCH_LINE STREQUAL "")
        message(FATAL_ERROR "Version '${VERSION_NAME}' not found")
    endif()

    # Extract the captured value (can be empty).
    set(${OUT_VAR} "${CMAKE_MATCH_1}")
endmacro()

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
    extract_version(MAJOR_VERSION "project_version_major" "${FILE_CONTENT}")

    # Minor version.
    extract_version(MINOR_VERSION "project_version_minor" "${FILE_CONTENT}")

    # Patch version.
    extract_version(PATCH_VERSION "project_version_patch" "${FILE_CONTENT}")

    # Optional pre-release tag (string literal).
    extract_optional_version_str(PRERELEASE_VERSION "project_version_prerelease" "${FILE_CONTENT}")

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
