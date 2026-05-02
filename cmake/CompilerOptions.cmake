#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add default compiler options to the provided target.
#
# Usage:
# ~~~
#   add_default_compiler_options(<target>
#       [WARNINGS_AS_ERRORS]
#   )
# ~~~
#
# Arguments:
#
# - WARNINGS_AS_ERRORS: Option to treat warnings as errors. If not provided, warnings will not be
#   treated as errors.
function(add_default_compiler_options target_name)
    message(CHECK_START "Adding default compiler options for target ${target_name}")

    set(options WARNINGS_AS_ERRORS)
    set(one_value_args)
    set(multi_value_args)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    set(mscl_options
        # ~~~
        # Displays level 1 to level 4 (informational) warnings.
        # ~~~
        /W4
    )

    set(clang_options
        # Enable most warning messages.
        -Wall
        # Enable some extra warnings.
        -Wextra
        # Issue all the warnings demanded by strict ISO C and ISO C++.
        -Wpedantic
        # Warn if something being unused.
        -Wunused
        # Warn if an old-style (C-style) cast to a non-void type is used within a C++ program.
        -Wold-style-cast
        # Warn if a pointer is cast such that the required alignment of the target is increased.
        -Wcast-align
        # Warn whenever a variable or type declaration shadows another one.
        -Wshadow
        # Warn if a class with virtual functions has a non-virtual destructor.
        -Wnon-virtual-dtor
        # Warn when a function declaration hides virtual functions from a base class.
        -Woverloaded-virtual
        # Warn for implicit conversions that may alter a value.
        -Wconversion
        # Warn for implicit conversions that may change the sign of an integer value.
        -Wsign-conversion
        # Warn when a value of type float is implicitly promoted to double.
        -Wdouble-promotion
        # Warn if the compiler detects a null pointer dereference.
        -Wnull-dereference
        # Enable -Wformat plus additional format checks (calls to printf and scanf, etc).
        -Wformat=2
        # Warn on statements that fallthrough without an explicit annotation.
        -Wimplicit-fallthrough
    )

    set(gcc_options
        ${clang_options}
        # Warn when the indentation of the code does not reflect the block structure.
        -Wmisleading-indentation
        # Warn about duplicated conditions in an if-else-if chain.
        -Wduplicated-cond
        # Warn when an if-else has identical branches.
        -Wduplicated-branches
        # Warn about suspicious uses of logical operators in expressions.
        -Wlogical-op
        # Warn when an expression is cast to its own type.
        -Wuseless-cast
        # Warn about overriding virtual functions that are not marked with the override keyword.
        -Wsuggest-override
    )

    if(arg_WARNINGS_AS_ERRORS)
        message(STATUS "Compilation warnings will be treated as errors")
        list(APPEND mscl_options /WX)
        list(APPEND clang_options -Werror)
        list(APPEND gcc_options -Werror)
    endif()

    if((CMAKE_CXX_COMPILER_ID STREQUAL "MSVC") OR (CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL
                                                   "MSVC")
    )
        set(compiler_options ${mscl_options})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(compiler_options ${clang_options})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(compiler_options ${gcc_options})
    else()
        message(AUTHOR_WARNING "No compiler options set for ${CMAKE_CXX_COMPILER_ID}")
    endif()

    target_compile_options(${target_name} INTERFACE ${compiler_options})
endfunction()
