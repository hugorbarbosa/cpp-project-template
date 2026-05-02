#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add the given sanitize compiler options to the provided target.
#
# Usage:
# ~~~
#   add_sanitize_compiler_options(<target> <sanitize_list>)
# ~~~
function(add_sanitize_compiler_options target_name sanitize_list)
    if(sanitize_list)
        string(REPLACE ";" "," sanitize_options "${sanitize_list}")
        set(sanitize_compiler_options
            # Runtime checks for various forms of undefined or suspicious behavior.
            -fsanitize=${sanitize_options}
            # Produce debugging information.
            -g
            # Reduce compilation time and make debugging produce the expected results.
            -O0
            # Do not omit the frame pointer in functions that don’t need one (to get nice stack
            # traces in error messages).
            -fno-omit-frame-pointer
        )

        if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
            message(
                FATAL_ERROR
                    "Sanitizers only for Clang or GCC, not available for ${CMAKE_CXX_COMPILER_ID}"
            )
        endif()

        target_compile_options(${target_name} INTERFACE ${sanitize_compiler_options})
        target_link_options(${target_name} INTERFACE ${sanitize_compiler_options})

        message(
            STATUS "Added sanitize compiler options for target ${target_name}: ${sanitize_options}"
        )
    else()
        message(STATUS "No sanitize compiler options added")
    endif()
endfunction()

# Add sanitizers to the provided target.
#
# Usage:
# ~~~
#   add_sanitizers(<target>
#       [ASAN <ON/OFF>]
#       [LSAN <ON/OFF>]
#       [MSAN <ON/OFF>]
#       [TSAN <ON/OFF>]
#       [UBSAN <ON/OFF>]
#   )
# ~~~
#
# Arguments:
#
# - ASAN: Optional flag to enable Address Sanitizer. If not provided, the default value is OFF.
# - LSAN: Optional flag to enable Leak Sanitizer. If not provided, the default value is OFF.
# - MSAN: Optional flag to enable Memory Sanitizer. If not provided, the default value is OFF.
# - TSAN: Optional flag to enable Thread Sanitizer. If not provided, the default value is OFF.
# - UBSAN: Optional flag to enable Undefined Behavior Sanitizer. If not provided, the default value
#   is OFF.
function(add_sanitizers target_name)
    message(CHECK_START "Adding sanitizers to the target ${target_name}")

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Sanitizers in a non-Debug build may not give meaningful output")
    endif()

    set(options)
    set(one_value_args ASAN LSAN MSAN TSAN UBSAN)
    set(multi_value_args)

    cmake_parse_arguments(arg "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    set(sanitizer_list)
    if(arg_ASAN)
        list(APPEND sanitizer_list "address")
    endif()
    if(arg_LSAN)
        list(APPEND sanitizer_list "leak")
    endif()
    if(arg_MSAN)
        if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            message(FATAL_ERROR "Memory Sanitizer is only supported by Clang compiler")
        elseif(
            arg_ASAN
            OR arg_LSAN
            OR arg_TSAN
        )
            message(
                FATAL_ERROR
                    "Memory Sanitizer does not work with Address, Leak or Thread Sanitizer enabled"
            )
        else()
            message(STATUS "Memory Sanitizer requires the instrumentation of all the code, including
                    libc++"
            )
            list(APPEND sanitizer_list "memory")
        endif()
    endif()
    if(arg_TSAN)
        if(arg_ASAN OR arg_LSAN)
            message(
                FATAL_ERROR "Thread Sanitizer does not work with Address or Leak Sanitizer enabled"
            )
        else()
            list(APPEND sanitizer_list "thread")
        endif()
    endif()
    if(arg_UBSAN)
        list(APPEND sanitizer_list "undefined")
    endif()

    message(CHECK_START "Adding sanitize compiler options for target ${target_name}")
    add_sanitize_compiler_options(${target_name} "${sanitizer_list}")
    message(CHECK_PASS "done")

    message(CHECK_PASS "done")
endfunction()
