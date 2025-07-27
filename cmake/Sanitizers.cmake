#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add the sanitize compiler options to the provided target.
#
# Parameters:
#
# - target_name: Name of the target to add sanitize compiler options.
# - sanitize_list: List of the sanitize compiler options.
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

# Enable sanitizers for the provided target.
#
# Parameters:
#
# - target_name: Name of the target to add sanitizers options.
# - enable_asan: Flag to enable Address Sanitizer.
# - enable_lsan: Flag to enable Leak Sanitizer.
# - enable_msan: Flag to enable Memory Sanitizer.
# - enable_tsan: Flag to enable Thread Sanitizer.
# - enable_ubsan: Flag to enable Undefined Behavior Sanitizer.
function(
    enable_sanitizers
    target_name
    enable_asan
    enable_lsan
    enable_msan
    enable_tsan
    enable_ubsan
)
    message(CHECK_START "Enabling sanitizers for target ${target_name}")

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Sanitizers in a non-Debug build may not give meaningful output")
    endif()

    set(sanitizer_list)

    if(enable_asan)
        list(APPEND sanitizer_list "address")
    endif()

    if(enable_lsan)
        list(APPEND sanitizer_list "leak")
    endif()

    if(enable_msan)
        if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            message(FATAL_ERROR "Memory Sanitizer is only supported by Clang compiler")
        elseif(
            enable_asan
            OR enable_lsan
            OR enable_tsan
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

    if(enable_tsan)
        if(enable_asan OR enable_lsan)
            message(
                FATAL_ERROR "Thread Sanitizer does not work with Address or Leak Sanitizer enabled"
            )
        else()
            list(APPEND sanitizer_list "thread")
        endif()
    endif()

    if(enable_ubsan)
        list(APPEND sanitizer_list "undefined")
    endif()

    message(CHECK_START "Adding sanitize options to compiler")
    add_sanitize_compiler_options(${target_name} "${sanitizer_list}")
    message(CHECK_PASS "done")

    message(CHECK_PASS "done")
endfunction()
