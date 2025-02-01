# ----------------------------------------------------------------------------
# Project setup
# ----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)

project(cpp_project_template
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "A C++ project template."
)

set(CXXPROJT_PROJECT_NAME ${PROJECT_NAME})
set(CXXPROJT_PROJECT_VERSION ${PROJECT_VERSION})

set(MAIN_PROJECT OFF)
if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(MAIN_PROJECT ON)
endif()

# ----------------------------------------------------------------------------
# Configuration options
# ----------------------------------------------------------------------------
option(CXXPROJT_BUILD_TESTS "Build tests" ${MAIN_PROJECT})
option(CXXPROJT_BUILD_COVERAGE "Build with code coverage" OFF)

if(CXXPROJT_BUILD_COVERAGE)
    set(CXXPROJT_BUILD_TESTS ON)
endif()

# ----------------------------------------------------------------------------
# CMake options
# ----------------------------------------------------------------------------
# Build type on single-configuration generators (e.g. Makefile generators or Ninja).
# Set default build type if build type not set.
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Build type (configuration) on multi-config generators (e.g. Visual Studio, Xcode, or Ninja
# Multi-Config).
# Set default configuration type if configuration type not set.
if(NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES Debug)
endif()

# ----------------------------------------------------------------------------
# Dependencies
# ----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
include(FetchDependencies)

# ----------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 20)

include(CompilerOptions)
set_compiler_options()

if(CXXPROJT_BUILD_COVERAGE)
    set_coverage_compiler_options()
endif()

add_subdirectory(src)

if(CXXPROJT_BUILD_TESTS)
    include(CTest)
    include(GoogleTest)
    enable_testing()
    add_subdirectory(test)
endif()

# ----------------------------------------------------------------------------
# Status
# ----------------------------------------------------------------------------
message(STATUS)
message(STATUS "${CXXPROJT_PROJECT_NAME} ${CXXPROJT_PROJECT_VERSION} configuration:")
message(STATUS "- CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
message(STATUS "- CMAKE_CXX_COMPILER_ID = ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "- CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}")
message(STATUS "- CXXPROJT_BUILD_TESTS = ${CXXPROJT_BUILD_TESTS}")
message(STATUS "- CXXPROJT_BUILD_COVERAGE = ${CXXPROJT_BUILD_COVERAGE}")
message(STATUS)
