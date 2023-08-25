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

target_link_libraries(${PROJECT_NAME}
    PRIVATE ProjectTemplate::Adder
)

# Generate executable in a specific directory
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
