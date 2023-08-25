# ----------------------------------------------------------------------------
# Project setup
project(AdderTest)

# ----------------------------------------------------------------------------
# Executable
add_executable(${PROJECT_NAME}
    AdderTest.cpp
)

# ----------------------------------------------------------------------------
# Tests
gtest_discover_tests(${PROJECT_NAME})

# ----------------------------------------------------------------------------
# Build

target_link_libraries(${PROJECT_NAME}
    PRIVATE GTest::gtest_main
    # Uncomment gmock library if a GMock is used in the test suite
    # PRIVATE GTest::gmock
    PRIVATE ProjectTemplate::Adder
)
