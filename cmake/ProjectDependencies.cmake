#
# Copyright (C) 2025 Hugo Barbosa.
#

include(FetchContent)

# Fetch googletest.
function(fetch_googletest)
    message(CHECK_START "Fetching GoogleTest")
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG release-1.11.0
    )
    # For Windows: Prevent overriding the parent project's compiler/linker settings.
    set(GTEST_FORCE_SHARED_CRT
        ON
        CACHE BOOL "" FORCE
    )
    FetchContent_MakeAvailable(googletest)
    message(CHECK_PASS "done")
endfunction()

# Fetch project dependencies.
#
# Parameters:
#
# - fetch_tests_deps: Flag to indicate if it should fetch also dependencies that are only for tests.
function(fetch_project_dependencies fetch_tests_deps)
    message(CHECK_START "Fetching project dependencies")
    if(fetch_tests_deps)
        fetch_googletest()
    endif()
    message(CHECK_PASS "done")
endfunction()
