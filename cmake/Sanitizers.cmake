#
# Copyright (C) 2025 Hugo Barbosa.
#

# Add the sanitize compiler options to the provided target.
#
# Parameters: TARGET_NAME: Name of the target to add sanitize compiler options. SANITIZE_LIST: List
# of the sanitize compiler options.
function(add_sanitize_compiler_options TARGET_NAME SANITIZE_LIST)
    if(SANITIZE_LIST)
        string(REPLACE ";" "," SANITIZE_OPTIONS "${SANITIZE_LIST}")
        set(SANITIZE_COMPILER_OPTIONS
            # Runtime checks for various forms of undefined or suspicious behavior.
            -fsanitize=${SANITIZE_OPTIONS}
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

        target_compile_options(${TARGET_NAME} INTERFACE ${SANITIZE_COMPILER_OPTIONS})
        target_link_options(${TARGET_NAME} INTERFACE ${SANITIZE_COMPILER_OPTIONS})

        message(
            STATUS "Added sanitize compiler options for target ${TARGET_NAME}: ${SANITIZE_OPTIONS}"
        )
    else()
        message(STATUS "No sanitize compiler options added")
    endif()
endfunction()

# Enable sanitizers for the provided target.
#
# Parameters: TARGET_NAME: Name of the target to add sanitizers options. ENABLE_ASAN: Flag to enable
# Address Sanitizer. ENABLE_LSAN: Flag to enable Leak Sanitizer. ENABLE_MSAN: Flag to enable Memory
# Sanitizer. ENABLE_TSAN: Flag to enable Thread Sanitizer. ENABLE_UBSAN: Flag to enable Undefined
# Behavior Sanitizer.
function(
    enable_sanitizers
    TARGET_NAME
    ENABLE_ASAN
    ENABLE_LSAN
    ENABLE_MSAN
    ENABLE_TSAN
    ENABLE_UBSAN
)
    message(CHECK_START "Enabling sanitizers for target ${TARGET_NAME}")

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(WARNING "Sanitizers in a non-Debug build may not give meaningful output")
    endif()

    # Sanitizers.
    set(SANITIZER_LIST)

    if(ENABLE_ASAN)
        list(APPEND SANITIZER_LIST "address")
    endif()

    if(ENABLE_LSAN)
        list(APPEND SANITIZER_LIST "leak")
    endif()

    if(ENABLE_MSAN)
        if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            message(FATAL_ERROR "Memory Sanitizer is only supported by Clang compiler")
        elseif(
            ENABLE_ASAN
            OR ENABLE_LSAN
            OR ENABLE_TSAN
        )
            message(
                FATAL_ERROR
                    "Memory Sanitizer does not work with Address, Leak or Thread Sanitizer enabled"
            )
        else()
            message(
                STATUS
                    "Memory Sanitizer requires the instrumentation of all the code, including libc++"
            )
            list(APPEND SANITIZER_LIST "memory")
        endif()
    endif()

    if(ENABLE_TSAN)
        if(ENABLE_ASAN OR ENABLE_LSAN)
            message(
                FATAL_ERROR "Thread Sanitizer does not work with Address or Leak Sanitizer enabled"
            )
        else()
            list(APPEND SANITIZER_LIST "thread")
        endif()
    endif()

    if(ENABLE_UBSAN)
        list(APPEND SANITIZER_LIST "undefined")
    endif()

    # Compiler options.
    message(CHECK_START "Adding sanitize options to compiler")
    add_sanitize_compiler_options(${TARGET_NAME} "${SANITIZER_LIST}")
    message(CHECK_PASS "done")

    message(CHECK_PASS "done")
endfunction()
