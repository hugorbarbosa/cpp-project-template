# ----------------------------------------------------------------------------
# Project setup
project(AdderTest)

enable_testing()

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

target_include_directories(${PROJECT_NAME}
    PRIVATE ${CMAKE_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE GTest::gtest_main
    # PRIVATE GTest::gmock
    PRIVATE ProjectTemplate::Adder
)
