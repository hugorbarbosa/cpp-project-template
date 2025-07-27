#
# Copyright (C) 2025 Hugo Barbosa.
#

# Enable source code documentation generation, using doxygen.
#
# Parameters:
#
# - config_file: Doxygen configuration file.
# - project: Project name used to update the respective option in the configuration file.
# - version: Project version used to update the respective option in the configuration file.
# - brief: Project brief used to update the respective option in the configuration file.
# - input: Input directories/files, separated with spaces, used to update the respective option in
#   the configuration file.
# - out_dir: Output directory used to update the respective option in the configuration file.
# - log_file: Log file to be created with the doxygen output.
function(
    enable_doxygen_doc
    config_file
    project
    version
    brief
    input
    out_dir
    log_file
)
    message(CHECK_START "Enabling doxygen documentation generation")

    # Requirements.
    message(CHECK_START "Checking needed tools")
    find_program(doxygen_path doxygen REQUIRED)
    execute_process(
        COMMAND ${doxygen_path} --version
        OUTPUT_VARIABLE doxygen_version
        ERROR_VARIABLE doxygen_version
    )
    message(STATUS "Doxygen: ${doxygen_version}")
    message(CHECK_PASS "done")

    # Generate the configuration file using the configuration variables.
    set(doxygen_project_name "\"${project}\"")
    set(doxygen_project_number "${version}")
    set(doxygen_project_brief "\"${brief}\"")
    set(doxygen_input "${input}")
    set(doxygen_output_directory "${out_dir}")
    set(config_file_out "${CMAKE_BINARY_DIR}/Doxyfile")
    configure_file(${config_file} ${config_file_out} @ONLY)

    set(report_file "${CMAKE_BINARY_DIR}/${log_file}")
    set(doxygen_index_file "${out_dir}/index.html")

    add_custom_target(
        doxygen
        COMMENT "Generate doxygen documentation for project ${project}"
        COMMAND ${CMAKE_COMMAND} -E echo "Running doxygen"
        COMMAND ${CMAKE_COMMAND} -E echo "Report: ${report_file}"
        COMMAND ${CMAKE_COMMAND} -E echo "Generated doc index: ${doxygen_index_file}"
        COMMAND ${doxygen_path} ${config_file_out} > ${report_file} 2>&1
        BYPRODUCTS ${report_file} ${doxygen_index_file} ${config_file_out}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        VERBATIM
    )

    message(CHECK_PASS "done")
endfunction()
