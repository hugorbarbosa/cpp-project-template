# ----------------------------------------------------------------------------
# Project setup
project(MockExample)

# ----------------------------------------------------------------------------
# Library
add_library(${PROJECT_NAME} STATIC
    MockExample.h
)
add_library(ProjectTemplate::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ----------------------------------------------------------------------------
# Build

target_link_libraries(${PROJECT_NAME}
    PRIVATE GTest::gmock
    # Replace by the library that contains the entity to mock
    # PRIVATE ProjectTemplate::Example
)
