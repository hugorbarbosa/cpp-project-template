#
# Copyright (C) 2025 Hugo Barbosa.
#

set(GIT_INFO_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(GIT_INFO_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/git_info")

# Get the project git information, namely the git branch and commit hash.
#
# Usage:
# ~~~
#   get_git_info(<prefix>)
# ~~~
#
# Note: The information is returned through variables defined with the prefix provided, i.e.,
# "${prefix}_BRANCH" and "${prefix}_COMMIT_HASH".
function(get_git_info prefix)
    message(CHECK_START "Getting the project git information")

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(git_executable git REQUIRED)
    execute_process(
        COMMAND ${git_executable} --version
        OUTPUT_VARIABLE git_version
        ERROR_VARIABLE git_version
    )
    message(STATUS "Git: ${git_version}")
    message(CHECK_PASS "done")

    execute_process(
        COMMAND ${git_executable} rev-parse --abbrev-ref HEAD
        OUTPUT_VARIABLE branch
        OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    execute_process(
        COMMAND ${git_executable} rev-parse --short HEAD
        OUTPUT_VARIABLE commit
        OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    message(STATUS "Project git branch: ${branch}")
    message(STATUS "Project git commit hash: ${commit}")

    # Set variables to be used in the parent scope.
    set(${prefix}_BRANCH
        ${branch}
        PARENT_SCOPE
    )
    set(${prefix}_COMMIT_HASH
        ${commit}
        PARENT_SCOPE
    )

    message(CHECK_PASS "done")
endfunction()

# Check if the argument with the given name was provided.
macro(check_required_arg prefix arg_name)
    if(NOT ${prefix}_${arg_name})
        message(FATAL_ERROR "Missing required argument: ${arg_name}")
    endif()
endmacro()

# Generate header file with the provided git information.
#
# Usage:
# ~~~
#   generate_git_info_file(
#       GIT_BRANCH <branch>
#       GIT_COMMIT_HASH <hash>
#       [HEADER_FILE_NAME <file>]
#       HEADER_GUARD <include_guard>
#       HEADER_NAMESPACE <namespace>
#   )
# ~~~
#
# Arguments:
#
# - GIT_BRANCH: Git branch to be added to the header file.
# - GIT_COMMIT_HASH: Git commit hash to be added to the header file.
# - HEADER_FILE_NAME: Optional name for the header file that will be generated containing the git
#   information. This file will be created in the build directory. If not provided, the default
#   value is "git_info.hpp".
# - HEADER_GUARD: Include guard to be used in the header file.
# - HEADER_NAMESPACE: Namespace to be used in the header file.
function(generate_git_info_file)
    message(CHECK_START "Generating header file with the project git information")

    set(options)
    set(one_value_args GIT_BRANCH GIT_COMMIT_HASH HEADER_FILE_NAME HEADER_GUARD HEADER_NAMESPACE)
    set(multi_value_args)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    # Required arguments.
    check_required_arg(arg GIT_BRANCH)
    check_required_arg(arg GIT_COMMIT_HASH)
    check_required_arg(arg HEADER_GUARD)
    check_required_arg(arg HEADER_NAMESPACE)

    message(STATUS "Provided git branch: ${arg_GIT_BRANCH}")
    message(STATUS "Provided git commit hash: ${arg_GIT_COMMIT_HASH}")

    file(MAKE_DIRECTORY ${GIT_INFO_OUT_DIR})

    # Header file to be configured.
    set(header_file_in "${GIT_INFO_DIR}/git_info/git_info.hpp.in")

    # Generate the header file using the configuration variables.
    set(git_info_branch "${arg_GIT_BRANCH}")
    set(git_info_commit_hash "${arg_GIT_COMMIT_HASH}")
    set(git_info_header_guard "${arg_HEADER_GUARD}")
    set(git_info_namespace "${arg_HEADER_NAMESPACE}")
    if(NOT arg_HEADER_FILE_NAME)
        set(arg_HEADER_FILE_NAME "git_info.hpp")
        message(STATUS "Header file name not provided. Using: ${arg_HEADER_FILE_NAME}")
    endif()
    set(header_file_out "${GIT_INFO_OUT_DIR}/${arg_HEADER_FILE_NAME}")
    configure_file(${header_file_in} ${header_file_out} @ONLY)

    message(STATUS "Generated header file with project git information: ${header_file_out}")

    message(CHECK_PASS "done")
endfunction()

# Add git info directory to the included directories of the provided target.
function(target_include_git_info_directory target_name)
    target_include_directories(${target_name} PRIVATE ${GIT_INFO_OUT_DIR})
endfunction()
