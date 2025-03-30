# Add clang-format target.
#
# Parameters:
#   script_path: Script path.
function(add_clang_format_target script_path)
    find_program(CLANG_FORMAT_PATH clang-format REQUIRED)
    execute_process(
        COMMAND ${CLANG_FORMAT_PATH} --version
        OUTPUT_VARIABLE CLANG_FORMAT_VERSION
        ERROR_VARIABLE CLANG_FORMAT_VERSION
    )
    message(STATUS "Clang-format: ${CLANG_FORMAT_VERSION}")

    add_custom_target(format
        COMMAND ${script_path} -b ${CMAKE_BINARY_DIR}
        COMMENT "Run clang-format checker"
    )
endfunction()
