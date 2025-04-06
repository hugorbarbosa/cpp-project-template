# ----------------------------------------------------------------------------
# Project setup
# ----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.17)

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
option(CXXPROJT_ENABLE_COVERAGE "Enable code coverage analysis" OFF)
option(CXXPROJT_ENABLE_FORMAT "Enable code formatting check" OFF)

if(CXXPROJT_ENABLE_COVERAGE)
    set(CXXPROJT_BUILD_TESTS ON)
endif()

# ----------------------------------------------------------------------------
# CMake options
# ----------------------------------------------------------------------------
# Build type on single-configuration generators (e.g. Makefile or Ninja).
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
include(ProjectDependencies)
fetch_project_dependencies(${CXXPROJT_BUILD_TESTS})

# ----------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------
if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
endif()

include(CompilerOptions)
set_compiler_options()

set(SCRIPTS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/scripts)

if(CXXPROJT_ENABLE_COVERAGE)
    include(CodeCoverage)
    set(EXCLUDE_PATTERNS
        "/usr/include/*"
        "/usr/local/*"
        "*/_deps/*"
        "${CMAKE_CURRENT_SOURCE_DIR}/test/*"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
    )
    set(MIN_LINE_COVERAGE 90)
    set(MIN_FUNCTION_COVERAGE 80)
    set(JOBS 4)
    set(SCRIPT_PATH ${SCRIPTS_DIR}/coverage-report-checker.sh)
    enable_coverage(
        "${EXCLUDE_PATTERNS}"
        ${MIN_LINE_COVERAGE}
        ${MIN_FUNCTION_COVERAGE}
        ${JOBS}
        ${SCRIPT_PATH}
    )
endif()

add_subdirectory(src)

if(CXXPROJT_BUILD_TESTS)
    include(CTest)
    include(GoogleTest)
    enable_testing()
    add_subdirectory(test)
endif()

if(CXXPROJT_ENABLE_FORMAT)
    include(ClangFormat)
    add_clang_format_target(${SCRIPTS_DIR}/clang-format-checker.sh)
endif()

# ----------------------------------------------------------------------------
# Configuration report
# ----------------------------------------------------------------------------
message(STATUS)
message(STATUS "${CXXPROJT_PROJECT_NAME} ${CXXPROJT_PROJECT_VERSION} configuration:")
message(STATUS "- CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
message(STATUS "- CMAKE_CXX_COMPILER_ID = ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "- CMAKE_CXX_COMPILER_VERSION = ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "- CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}")
message(STATUS "- CXXPROJT_BUILD_TESTS = ${CXXPROJT_BUILD_TESTS}")
message(STATUS "- CXXPROJT_ENABLE_COVERAGE = ${CXXPROJT_ENABLE_COVERAGE}")
message(STATUS "- CXXPROJT_ENABLE_FORMAT = ${CXXPROJT_ENABLE_FORMAT}")
message(STATUS)
