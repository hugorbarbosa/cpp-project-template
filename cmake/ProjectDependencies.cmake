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
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
    message(CHECK_PASS "done")
endfunction()

# Fetch project dependencies.
#
# Parameters:
#   build_tests: Flag to indicate if the build includes tests.
function(fetch_project_dependencies build_tests)
    message(CHECK_START "Fetching project dependencies")
    if (build_tests)
        fetch_googletest()
    endif()
    message(CHECK_PASS "done")
endfunction()
