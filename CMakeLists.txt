# ----------------------------------------------------------------------------
# Project setup

cmake_minimum_required(VERSION 3.16)

project(ProjectTemplate
    VERSION 1.0.0
    LANGUAGES CXX
)

# ----------------------------------------------------------------------------
# Configuration options

# Option to build unit tests
option(BUILD_TESTS "Build unit tests" OFF)
# Option to build with code coverage
option(BUILD_COVERAGE "Build with code coverage" OFF)

# ----------------------------------------------------------------------------
# CMake options

# Build type on single-configuration generators (e.g. Makefile generators or Ninja).
# Set default build type if build type not set.
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Build type (configuration) on multi-config generators (e.g. Visual Studio, Xcode, or Ninja Multi-Config).
# Set default configuration type if configuration type not set.
if (NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES Debug)
endif()

# ----------------------------------------------------------------------------
# Dependencies

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Fetch dependencies
include(FetchDependencies)

# ----------------------------------------------------------------------------
# Compile definitions

# Set build debug definition
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(BUILD_DEBUG)
endif()

# Set build tests definition
if (BUILD_TESTS)
    add_compile_definitions(BUILD_TESTS)
endif()

# ----------------------------------------------------------------------------
# Test

if (BUILD_TESTS)
    include(CTest)
    include(GoogleTest)
    enable_testing()
endif()

# ----------------------------------------------------------------------------
# Build

# C++ standard
set(CMAKE_CXX_STANDARD 20)

# Set compile options for GCC
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -Wall -Werror"
    )
endif()

# Set compile options for MSVC
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} /W4 /WX"
    )
endif()

# Code coverage
if(BUILD_COVERAGE)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS
            "${CMAKE_CXX_FLAGS} --coverage -g -O0"
        )
    endif()
endif()

# Subdirectories
add_subdirectory(src)
if (BUILD_TESTS)
    add_subdirectory(tests)
endif()

# ----------------------------------------------------------------------------
# Status
message(STATUS)
message(STATUS "${PROJECT_NAME} configuration:")
message(STATUS "- CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
# message(STATUS "- CMAKE_CONFIGURATION_TYPES = ${CMAKE_CONFIGURATION_TYPES}")
message(STATUS "- CMAKE_CXX_COMPILER_ID = ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "- CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}")
# message(STATUS "- CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}")
message(STATUS "- BUILD_TESTS = ${BUILD_TESTS}")
message(STATUS "- BUILD_COVERAGE = ${BUILD_COVERAGE}")
message(STATUS)
