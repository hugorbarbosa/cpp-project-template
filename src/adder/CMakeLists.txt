# ----------------------------------------------------------------------------
# Project setup
project(Adder)

# ----------------------------------------------------------------------------
# Library
add_library(${PROJECT_NAME} STATIC
    Adder.cpp
)
add_library(ProjectTemplate::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# ----------------------------------------------------------------------------
# Build
target_include_directories(${PROJECT_NAME}
    PUBLIC .
)
