#
# Copyright (C) 2025 Hugo Barbosa.
#

# Extract version value from the provided version name and content.
#
# Parameters:
#
# - out_var: Output variable that will contain the extracted version.
# - version_name: Version name (major, minor, etc).
# - content: Content from which the version should be extracted.
macro(EXTRACT_VERSION out_var version_name content)
    set(regex_pattern "${version_name}[ \t]*=[ \t]*([0-9]+)")

    unset(CMAKE_MATCH_1)
    string(REGEX MATCH "${regex_pattern}" _ "${content}")
    if(NOT DEFINED CMAKE_MATCH_1)
        message(FATAL_ERROR "Version '${version_name}' not found")
    endif()

    set(${out_var} "${CMAKE_MATCH_1}")
endmacro()

# Extract an optional version string from the provided version name and content.
#
# Parameters:
#
# - out_var: Output variable that will contain the extracted version.
# - version_name: Version name (prerelease, etc).
# - content: Content from which the version should be extracted.
macro(EXTRACT_OPTIONAL_VERSION_STR out_var version_name content)
    # Match: key = "some string" or key = "".
    set(regex_pattern "${version_name}[ \t]*=[ \t]*\"([^\"]*)\"")

    unset(CMAKE_MATCH_1)
    unset(MATCH_LINE)

    # Match the full line to ensure it exists.
    string(REGEX MATCH "${regex_pattern}" MATCH_LINE "${content}")
    if(MATCH_LINE STREQUAL "")
        message(FATAL_ERROR "Version '${version_name}' not found")
    endif()

    # Extract the captured value (can be empty).
    set(${out_var} "${CMAKE_MATCH_1}")
endmacro()

# Parse project version from the provided header file.
#
# Parameters:
#
# - header_file: Header file that contains the project version to be parsed.
function(parse_project_version header_file)
    message(CHECK_START "Parsing project version from header file ${header_file}")

    if(NOT EXISTS "${header_file}")
        message(FATAL_ERROR "Header file not found: ${header_file}")
    endif()

    file(READ "${header_file}" file_content)

    # Major version.
    extract_version(major_version "project_version_major" "${file_content}")

    # Minor version.
    extract_version(minor_version "project_version_minor" "${file_content}")

    # Patch version.
    extract_version(patch_version "project_version_patch" "${file_content}")

    # Optional pre-release tag (string literal).
    extract_optional_version_str(prerelease_version "project_version_prerelease" "${file_content}")

    # Version without prerelease.
    set(base_version "${major_version}.${minor_version}.${patch_version}")

    # Version with prerelease if exists.
    set(full_version ${base_version})
    if(prerelease_version)
        set(full_version "${base_version}-${prerelease_version}")
    endif()

    # Variables to be used in the parent scope.
    set(PROJECT_VERSION_BASE
        ${base_version}
        PARENT_SCOPE
    )
    set(PROJECT_VERSION_FULL
        ${full_version}
        PARENT_SCOPE
    )

    message(CHECK_PASS "done")
endfunction()
