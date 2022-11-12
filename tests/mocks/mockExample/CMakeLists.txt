# ----------------------------------------------------------------------------
# Project setup
project(MockExample)

# ----------------------------------------------------------------------------
# Source files
set(SOURCES
    MockExample.h
)

# ----------------------------------------------------------------------------
# Library
add_library(${PROJECT_NAME}
    STATIC ${SOURCES}
)
add_library(ProjectTemplate::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ----------------------------------------------------------------------------
# Build

target_include_directories(${PROJECT_NAME}
    PRIVATE ${CMAKE_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE GTest::gmock
    # PRIVATE ProjectTemplate::Example
)
