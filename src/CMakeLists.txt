# ----------------------------------------------------------------------------
# Project setup
project(ProjectTemplate)

# Subdirectories
add_subdirectory(adder)

# ----------------------------------------------------------------------------
# Executable
add_executable(${PROJECT_NAME}
    main.cpp
)

# ----------------------------------------------------------------------------
# Build

target_include_directories(${PROJECT_NAME}
    PRIVATE ${CMAKE_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE ProjectTemplate::Adder
)
