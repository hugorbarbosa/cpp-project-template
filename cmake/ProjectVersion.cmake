#
# Copyright (C) 2025 Hugo Barbosa.
#

# Extract version (number) from the provided version name (major, minor, etc) and content.
#
# The extracted result will be set to out_var.
macro(extract_version_number out_var version_name content)
    set(regex_pattern "${version_name}[ \t]*{[ \t]*([0-9]+)}")

    unset(CMAKE_MATCH_1)
    string(REGEX MATCH "${regex_pattern}" _ "${content}")
    if(NOT DEFINED CMAKE_MATCH_1)
        message(FATAL_ERROR "Version '${version_name}' not found")
    endif()

    set(${out_var} "${CMAKE_MATCH_1}")
endmacro()

# Extract version (string) from the provided version name (prerelease, etc) and content.
#
# The extracted result will be set to out_var (can be empty).
macro(extract_version_string out_var version_name content)
    # Match: key = "some string" or key = "".
    set(regex_pattern "${version_name}[ \t]*{[ \t]*\"([^\"]*)\"}")

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

# Get the project version from the provided version file.
#
# The expected variable name and format for the version specification in the file is:
#
# - Major version: "project_version_major{<version>}".
# - Minor version: "project_version_minor{<version>}".
# - Patch version: "project_version_patch{<version>}".
# - Optional pre-release tag: "project_version_prerelease{"<version>"}".
#
# Usage:
# ~~~
#   get_project_version(
#       VERSION_FILE <file>
#       PREFIX_OUT <prefix>
#   )
# ~~~
#
# Arguments:
#
# - VERSION_FILE: File from which the version will be extracted.
# - PREFIX_OUT: Prefix for the output variables: "<prefix>_VERSION_BASE" and
#   "<prefix>_VERSION_FULL". The "full" version includes the optional pre-release tag, comparing
#   with the "base" version.
function(get_project_version)
    message(CHECK_START "Getting project version")

    set(options)
    set(one_value_args VERSION_FILE PREFIX_OUT)
    set(multi_value_args)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    # Required arguments.
    if(NOT arg_VERSION_FILE)
        message(FATAL_ERROR "Missing required version file")
    endif()
    if(NOT arg_PREFIX_OUT)
        message(FATAL_ERROR "Missing required prefix")
    endif()

    if(NOT EXISTS "${arg_VERSION_FILE}")
        message(FATAL_ERROR "Version file not found: ${arg_VERSION_FILE}")
    endif()

    file(READ "${arg_VERSION_FILE}" file_content)

    extract_version_number(major_version "project_version_major" "${file_content}")
    extract_version_number(minor_version "project_version_minor" "${file_content}")
    extract_version_number(patch_version "project_version_patch" "${file_content}")
    extract_version_string(prerelease_version "project_version_prerelease" "${file_content}")

    # Version without prerelease.
    set(base_version "${major_version}.${minor_version}.${patch_version}")

    # Version with prerelease if exists.
    set(full_version ${base_version})
    if(prerelease_version)
        set(full_version "${base_version}-${prerelease_version}")
    endif()

    message(STATUS "Base version: ${base_version}")
    message(STATUS "Full version: ${full_version}")

    # Set variables to be used in the parent scope.
    set(${arg_PREFIX_OUT}_VERSION_BASE
        ${base_version}
        PARENT_SCOPE
    )
    set(${arg_PREFIX_OUT}_VERSION_FULL
        ${full_version}
        PARENT_SCOPE
    )

    message(CHECK_PASS "done")
endfunction()
