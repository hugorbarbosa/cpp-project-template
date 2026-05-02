#
# Copyright (C) 2025 Hugo Barbosa.
#

# Check if the argument with the given name was provided.
macro(check_required_arg prefix arg_name)
    if(NOT ${prefix}_${arg_name})
        message(FATAL_ERROR "Missing required argument: ${arg_name}")
    endif()
endmacro()

# Add a target for source code documentation generation using doxygen.
#
# This function configures the following parameters in the Doxyfile:
#
# - PROJECT_NAME: must be set to "@doxygen_project_name@" in the Doxyfile. This parameter will be
#   set with the respective argument value provided to this function.
# - PROJECT_NUMBER: must be set to "@doxygen_project_number@" in the Doxyfile. This parameter will
#   be set with the respective argument value provided to this function.
# - PROJECT_BRIEF: must be set to "@doxygen_project_brief@" in the Doxyfile. This parameter will be
#   set with the respective argument value provided to this function.
# - INPUT: must be set to "@doxygen_input@" in the Doxyfile. This parameter will be set with the
#   respective argument value provided to this function.
# - OUTPUT_DIRECTORY: must be set to "@doxygen_output_directory@" in the Doxyfile. This parameter
#   will be set with the respective argument value provided to this function.
#
# Usage:
# ~~~
#   add_doxygen(
#       DOXYFILE_IN <file>
#       [DOXYFILE_OUT <file>]
#       DOXYGEN_PROJECT_NAME <name>
#       DOXYGEN_PROJECT_NUMBER <number>
#       DOXYGEN_PROJECT_BRIEF <brief>
#       DOXYGEN_INPUT <dir1> <file1> [<dir2> ... <file2> ...]
#       DOXYGEN_OUTPUT_DIRECTORY <dir>
#       [LOG_FILE <file>]
#   )
# ~~~
#
# Arguments:
#
# - DOXYFILE_IN: Doxygen configuration file to be configured.
# - DOXYFILE_OUT: Optional doxygen configuration file that will be generated with the configured
#   parameters. If not provided, the default value is "${CMAKE_BINARY_DIR}/Doxyfile".
# - DOXYGEN_PROJECT_NAME: Project name used to update the respective option in the Doxyfile.
# - DOXYGEN_PROJECT_NUMBER: Project number used to update the respective option in the Doxyfile.
# - DOXYGEN_PROJECT_BRIEF: Project brief used to update the respective option in the Doxyfile.
# - DOXYGEN_INPUT: List of directories/files used to update the respective option in the Doxyfile.
# - DOXYGEN_OUTPUT_DIRECTORY: Output directory used to update the respective option in the Doxyfile.
# - LOG_FILE: Optional log file path to be created with the Doxygen output. If not provided, the
#   default value is "${CMAKE_BINARY_DIR}/doxygen_report.log".
function(add_doxygen)
    message(CHECK_START "Adding target for documentation generation using doxygen")

    set(options)
    set(one_value_args
        DOXYFILE_IN
        DOXYFILE_OUT
        DOXYGEN_PROJECT_NAME
        DOXYGEN_PROJECT_NUMBER
        DOXYGEN_PROJECT_BRIEF
        DOXYGEN_OUTPUT_DIRECTORY
        LOG_FILE
    )
    set(multi_value_args DOXYGEN_INPUT)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    # Required arguments.
    check_required_arg(arg DOXYFILE_IN)
    check_required_arg(arg DOXYGEN_PROJECT_NAME)
    check_required_arg(arg DOXYGEN_PROJECT_NUMBER)
    check_required_arg(arg DOXYGEN_PROJECT_BRIEF)
    check_required_arg(arg DOXYGEN_INPUT)
    check_required_arg(arg DOXYGEN_OUTPUT_DIRECTORY)

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(doxygen_executable doxygen REQUIRED)
    execute_process(
        COMMAND ${doxygen_executable} --version
        OUTPUT_VARIABLE doxygen_version
        ERROR_VARIABLE doxygen_version
    )
    message(STATUS "Doxygen: ${doxygen_version}")
    message(CHECK_PASS "done")

    # Generate the configuration file using the configuration variables.
    message(CHECK_START "Configuring Doxyfile with the provided arguments")
    set(doxygen_project_name "\"${arg_DOXYGEN_PROJECT_NAME}\"")
    set(doxygen_project_number "${arg_DOXYGEN_PROJECT_NUMBER}")
    set(doxygen_project_brief "\"${arg_DOXYGEN_PROJECT_BRIEF}\"")
    string(REPLACE ";" " " doxygen_input "${arg_DOXYGEN_INPUT}")
    set(doxygen_output_directory "${arg_DOXYGEN_OUTPUT_DIRECTORY}")
    if(NOT arg_DOXYFILE_OUT)
        set(arg_DOXYFILE_OUT "${CMAKE_BINARY_DIR}/Doxyfile")
        message(STATUS "Doxyfile to be generated not provided. Using: ${arg_DOXYFILE_OUT}")
    endif()
    message(STATUS "Doxyfile with the configured parameters: ${arg_DOXYFILE_OUT}")
    configure_file(${arg_DOXYFILE_IN} ${arg_DOXYFILE_OUT} @ONLY)
    message(CHECK_PASS "done")

    # Log file.
    if(NOT arg_LOG_FILE)
        set(arg_LOG_FILE "${CMAKE_BINARY_DIR}/doxygen_report.log")
        message(STATUS "Log file not provided. Using default value: ${arg_LOG_FILE}")
    endif()

    set(doxygen_index_file "${arg_DOXYGEN_OUTPUT_DIRECTORY}/html/index.html")

    add_custom_target(
        doxygen
        COMMENT "Generate doxygen documentation for project ${arg_DOXYGEN_PROJECT_NAME}"
        COMMAND ${CMAKE_COMMAND} -E echo "Running doxygen"
        COMMAND ${CMAKE_COMMAND} -E echo "Results will be saved in: ${arg_LOG_FILE}"
        COMMAND ${CMAKE_COMMAND} -E echo "Doc index will be saved in: ${doxygen_index_file}"
        COMMAND ${doxygen_executable} ${arg_DOXYFILE_OUT} > ${arg_LOG_FILE} 2>&1
        BYPRODUCTS ${arg_LOG_FILE} ${doxygen_index_file} ${arg_DOXYFILE_OUT}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        VERBATIM
    )

    message(CHECK_PASS "done")
endfunction()
