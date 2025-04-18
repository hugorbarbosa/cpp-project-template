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
option(CXXPROJT_ENABLE_DOXYGEN "Enable doxygen documentation generation" OFF)

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
    set(COVERAGE_EXCLUDE_PATTERNS
        "/usr/include/*"
        "/usr/local/*"
        "*/_deps/*"
        "${CMAKE_CURRENT_SOURCE_DIR}/test/*"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
    )
    set(MIN_LINE_COVERAGE 90)
    set(MIN_FUNCTION_COVERAGE 80)
    set(COVERAGE_JOBS 4)
    set(COVERAGE_CHECK_SCRIPT ${SCRIPTS_DIR}/coverage-report-checker.sh)
    enable_coverage(
        "${COVERAGE_EXCLUDE_PATTERNS}"
        ${MIN_LINE_COVERAGE}
        ${MIN_FUNCTION_COVERAGE}
        ${COVERAGE_JOBS}
        ${COVERAGE_CHECK_SCRIPT}
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
    set(FORMAT_DIRECTORIES
        "${CMAKE_CURRENT_SOURCE_DIR}/examples"
        "${CMAKE_CURRENT_SOURCE_DIR}/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/test"
    )
    set(FORMAT_LOG_FILE format-report.log)
    enable_format_check("${FORMAT_DIRECTORIES}" ${FORMAT_LOG_FILE})
endif()

if(CXXPROJT_ENABLE_DOXYGEN)
    include(DoxygenDoc)
    set(DOXYGEN_CONFIG_FILE ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/Doxyfile.in)
    set(DOXYGEN_PROJECT "C++ Project Template")
    set(DOXYGEN_VERSION ${CXXPROJT_PROJECT_VERSION})
    set(DOXYGEN_BRIEF "A C++ project template using CMake")
    set(DOXYGEN_INPUT_LIST
        "${CMAKE_CURRENT_SOURCE_DIR}/examples"
        "${CMAKE_CURRENT_SOURCE_DIR}/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/test"
    )
    string(REPLACE ";" " " DOXYGEN_INPUT "${DOXYGEN_INPUT_LIST}")
    set(DOXYGEN_OUT_DIR ${CMAKE_BINARY_DIR}/doxygen)
    set(DOXYGEN_LOG_FILE doxygen-report.log)
    enable_doxygen_doc(
        ${DOXYGEN_CONFIG_FILE}
        ${DOXYGEN_PROJECT}
        ${DOXYGEN_VERSION}
        ${DOXYGEN_BRIEF}
        ${DOXYGEN_INPUT}
        ${DOXYGEN_OUT_DIR}
        ${DOXYGEN_LOG_FILE}
    )
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
message(STATUS "- CXXPROJT_ENABLE_DOXYGEN = ${CXXPROJT_ENABLE_DOXYGEN}")
message(STATUS)
