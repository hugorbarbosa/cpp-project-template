# Set the compiler options for code coverage.
function(set_coverage_compiler_options)
    set(GCC_COVERAGE_OPTIONS
        # Compile and link code instrumented for coverage analysis.
        --coverage
        # Produce debugging information.
        -g
        # Reduce compilation time and make debugging produce the expected results.
        -O0
        # Add code so that program flow arcs are instrumented.
        -fprofile-arcs
        # Produce a notes file that the gcov utility can use.
        -ftest-coverage
        # Convert file names to absolute path names in the .gcno files.
        -fprofile-abs-path
    )

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_compile_options(${GCC_COVERAGE_OPTIONS})
        link_libraries(gcov)
    else()
        message(AUTHOR_WARNING "Coverage only for GCC, not available for ${CMAKE_CXX_COMPILER_ID}")
   endif()
endfunction()
