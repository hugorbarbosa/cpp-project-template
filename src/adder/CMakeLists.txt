# ----------------------------------------------------------------------------
# Project setup
project(Adder)

# ----------------------------------------------------------------------------
# Source files
set(SOURCES
    Adder.cpp
)

# ----------------------------------------------------------------------------
# Library
add_library(${PROJECT_NAME}
    STATIC ${SOURCES}
)
add_library(ProjectTemplate::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
