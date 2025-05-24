#
# Copyright (C) 2025 Hugo Barbosa.
#

set(GIT_INFO_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/git_info")

# Generate project git information file, namely with the git branch and commit hash.
#
# Parameters:
#   IN_FILE: Input file to be used as template to generate the git information file.
#   OUT_FILE: Output file to be generated that will contain the git information (it will be placed
#             in the build directory).
#   HEADER_GUARD: Header guard to be used in the generated file.
#   NAMESPACE: Namespace to be used in the generated file.
function(generate_git_info_file IN_FILE OUT_FILE HEADER_GUARD NAMESPACE)
    message(CHECK_START "Generating project git information file")

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(GIT_PATH git REQUIRED)
    execute_process(
        COMMAND ${GIT_PATH} --version
        OUTPUT_VARIABLE GIT_VERSION
        ERROR_VARIABLE GIT_VERSION
    )
    message(STATUS "Git: ${GIT_VERSION}")
    message(CHECK_PASS "done")

    execute_process(
        COMMAND ${GIT_PATH} rev-parse --abbrev-ref HEAD
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        COMMAND_ERROR_IS_FATAL ANY
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    execute_process(
        COMMAND ${GIT_PATH} rev-parse --short HEAD
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        COMMAND_ERROR_IS_FATAL ANY
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    message(STATUS "Project git branch: ${GIT_BRANCH}")
    message(STATUS "Project git commit hash: ${GIT_COMMIT_HASH}")

    file(MAKE_DIRECTORY ${GIT_INFO_OUT_DIR})

    # Generate the output file using the input file and the configuration variables.
    set(PROJECT_GIT_BRANCH "${GIT_BRANCH}")
    set(PROJECT_GIT_COMMIT_HASH "${GIT_COMMIT_HASH}")
    set(PROJECT_GIT_INFO_HEADER_GUARD "${HEADER_GUARD}")
    set(PROJECT_GIT_INFO_NAMESPACE "${NAMESPACE}")
    set(HEADER_FILE_OUT "${GIT_INFO_OUT_DIR}/${OUT_FILE}")
    configure_file(${IN_FILE} ${HEADER_FILE_OUT} @ONLY)

    message(STATUS "Generated project git information in file ${HEADER_FILE_OUT}")

    message(CHECK_PASS "done")
endfunction()

# Add include project git info directory to the provided target.
#
# Parameters:
#   TARGET_NAME: Name of the target to add include git info directory.
function(target_include_git_info_directory TARGET_NAME)
    target_include_directories(${TARGET_NAME} PRIVATE ${GIT_INFO_OUT_DIR})
endfunction()
