# Add clang-format target.
#
# Parameters:
#   SCRIPT_PATH: Format checker path.
function(add_clang_format_target SCRIPT_PATH)
    # Requirements.
    find_program(CLANG_FORMAT_PATH clang-format REQUIRED)
    execute_process(
        COMMAND ${CLANG_FORMAT_PATH} --version
        OUTPUT_VARIABLE CLANG_FORMAT_VERSION
        ERROR_VARIABLE CLANG_FORMAT_VERSION
    )
    message(STATUS "Clang-format: ${CLANG_FORMAT_VERSION}")

    # Target.
    add_custom_target(format
        COMMAND ${SCRIPT_PATH} -b ${CMAKE_BINARY_DIR}
        COMMENT "Run clang-format checker."
    )
endfunction()
