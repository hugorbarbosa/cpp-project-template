cmake_minimum_required(VERSION 3.16)

# TODO: Use "target_compile_options" instead of "add_compile_options".

# Set the compiler options.
function(set_compiler_options)
    # TODO: Add more compiler options.
    if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        add_compile_options(
            /W4 # Displays level 1 to level 4 (informational) warnings.
            /WX # Treat warnings as errors.
        )
    else()
        add_compile_options(
            -Wall # Enable most warning messages.
            -Werror # Make all warnings into errors.
        )
    endif()
endfunction()

# Set the compiler options for code coverage.
function(set_coverage_compiler_options)
    # Code coverage available only for GCC.
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_compile_options(
            --coverage # Compile and link code instrumented for coverage analysis.
            -g # Produce debugging information.
            -O0 # Reduce compilation time and make debugging produce the expected results.
        )
    endif()
endfunction()
