#
# Copyright (C) 2025 Hugo Barbosa.
#

set(GIT_INFO_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/git_info")

# Generate project git information file, namely with the git branch and commit hash.
#
# Parameters:
#
# - in_file: Input file to be used as template to generate the git information file.
# - out_file: Output file to be generated that will contain the git information (it will be placed
#   in the build directory).
# - header_guard: Header guard to be used in the generated file.
# - namespace: Namespace to be used in the generated file.
function(generate_git_info_file in_file out_file header_guard namespace)
    message(CHECK_START "Generating project git information file")

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(git_path git REQUIRED)
    execute_process(
        COMMAND ${git_path} --version
        OUTPUT_VARIABLE git_version
        ERROR_VARIABLE git_version
    )
    message(STATUS "Git: ${git_version}")
    message(CHECK_PASS "done")

    execute_process(
        COMMAND ${git_path} rev-parse --abbrev-ref HEAD
        OUTPUT_VARIABLE git_branch
        OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    execute_process(
        COMMAND ${git_path} rev-parse --short HEAD
        OUTPUT_VARIABLE git_commit_hash
        OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    message(STATUS "Project git branch: ${git_branch}")
    message(STATUS "Project git commit hash: ${git_commit_hash}")

    file(MAKE_DIRECTORY ${GIT_INFO_OUT_DIR})

    # Generate the output file using the input file and the configuration variables.
    set(project_git_branch "${git_branch}")
    set(project_git_commit_hash "${git_commit_hash}")
    set(project_git_info_header_guard "${header_guard}")
    set(project_git_info_namespace "${namespace}")
    set(header_file_out "${GIT_INFO_OUT_DIR}/${out_file}")
    configure_file(${in_file} ${header_file_out} @ONLY)

    message(STATUS "Generated project git information in file ${header_file_out}")

    message(CHECK_PASS "done")
endfunction()

# Add include project git info directory to the provided target.
#
# Parameters:
#
# - target_name: Name of the target to add include git info directory.
function(target_include_git_info_directory target_name)
    target_include_directories(${target_name} PRIVATE ${GIT_INFO_OUT_DIR})
endfunction()
