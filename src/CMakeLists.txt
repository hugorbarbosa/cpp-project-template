# ----------------------------------------------------------------------------
# Project setup
project(ProjectTemplate)

# Subdirectories
add_subdirectory(adder)

# ----------------------------------------------------------------------------
# Source files
set(SOURCES
    main.cpp
)

# ----------------------------------------------------------------------------
# Executables
add_executable(${PROJECT_NAME}
    ${SOURCES}
)

# ----------------------------------------------------------------------------
# Build

target_include_directories(${PROJECT_NAME}
    PRIVATE ${CMAKE_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE ProjectTemplate::Adder
)
