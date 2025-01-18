# ----------------------------------------------------------------------------
# Project setup
# ----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)

project(cpp_project_template
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "A C++ project template."
)

set(CPP_PROJECT_TEMPLATE_NAME ${PROJECT_NAME})

set(MAIN_PROJECT OFF)
if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(MAIN_PROJECT ON)
endif()

# ----------------------------------------------------------------------------
# Configuration options
# ----------------------------------------------------------------------------
option(CPP_PROJECT_TEMPLATE_BUILD_TESTS "Build tests" ${MAIN_PROJECT})
option(CPP_PROJECT_TEMPLATE_BUILD_COVERAGE "Build with code coverage" OFF)

if(CPP_PROJECT_TEMPLATE_BUILD_COVERAGE)
    set(CPP_PROJECT_TEMPLATE_BUILD_TESTS ON)
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
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(FetchDependencies)

# ----------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 20)

# TODO: Use target_compile_options instead of setting directly the CMake flags.
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /WX")
endif()

if(CPP_PROJECT_TEMPLATE_BUILD_COVERAGE)
    # Code coverage available only for GCC.
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -g -O0")
    endif()
endif()

add_subdirectory(src)

if(CPP_PROJECT_TEMPLATE_BUILD_TESTS)
    include(CTest)
    include(GoogleTest)
    enable_testing()
    add_subdirectory(test)
endif()

# ----------------------------------------------------------------------------
# Status
# ----------------------------------------------------------------------------
message(STATUS)
message(STATUS "${PROJECT_NAME} configuration:")
message(STATUS "- CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
message(STATUS "- CMAKE_CXX_COMPILER_ID = ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "- CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}")
message(STATUS "- CPP_PROJECT_TEMPLATE_BUILD_TESTS = ${CPP_PROJECT_TEMPLATE_BUILD_TESTS}")
message(STATUS "- CPP_PROJECT_TEMPLATE_BUILD_COVERAGE = ${CPP_PROJECT_TEMPLATE_BUILD_COVERAGE}")
message(STATUS)
