#
# Copyright (C) 2025 Hugo Barbosa.
#

# ----------------------------------------------------------------------------
# Project setup
# ----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.21)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
include(ProjectVersion)
set(version_file ${CMAKE_CURRENT_SOURCE_DIR}/src/version/version.hpp)
parse_project_version(${version_file})

project(
    cpp_project_template
    VERSION ${PROJECT_VERSION_BASE}
    LANGUAGES CXX
    DESCRIPTION "A C++ project template."
)

set(CPROJT_PROJECT_NAME ${PROJECT_NAME})
set(CPROJT_PROJECT_VERSION ${PROJECT_VERSION_FULL})

set(is_main_project OFF)
if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(is_main_project ON)
endif()

# ----------------------------------------------------------------------------
# Pre-requirements
# ----------------------------------------------------------------------------
include(SourceBuilds)
validate_build_directory()

# ----------------------------------------------------------------------------
# Project information
# ----------------------------------------------------------------------------
include(ProjectGitInfo)
set(header_template_file "${CMAKE_CURRENT_SOURCE_DIR}/cmake/project_git_info.hpp.in")
set(header_out_file "git_info.hpp")
set(header_guard "CPP_PROJECT_TEMPLATE_GIT_INFO_HPP")
set(namespace "cpp_project_template")
generate_git_info_file(${header_template_file} ${header_out_file} ${header_guard} ${namespace})

# ----------------------------------------------------------------------------
# Configuration options
# ----------------------------------------------------------------------------
option(CPROJT_BUILD_TESTS "Build tests" ${is_main_project})
option(CPROJT_ENABLE_COVERAGE "Enable code coverage analysis" OFF)
option(CPROJT_ENABLE_CLANG_FORMAT "Enable code formatting with clang-format" OFF)
option(CPROJT_ENABLE_CLANG_TIDY "Enable code static analysis with clang-tidy" OFF)
option(CPROJT_ENABLE_ASAN "Enable Address Sanitizer" OFF)
option(CPROJT_ENABLE_LSAN "Enable Leak Sanitizer" OFF)
option(CPROJT_ENABLE_MSAN "Enable Memory Sanitizer" OFF)
option(CPROJT_ENABLE_TSAN "Enable Thread Sanitizer" OFF)
option(CPROJT_ENABLE_UBSAN "Enable Undefined Behavior Sanitizer" OFF)
option(CPROJT_ENABLE_DOXYGEN "Enable doxygen documentation generation" OFF)
option(CPROJT_ENABLE_CMAKE_FORMAT "Enable CMake code formatting with cmake-format" OFF)
option(CPROJT_ENABLE_CMAKE_LINT "Enable CMake lint with cmake-lint" OFF)

if(CPROJT_ENABLE_COVERAGE)
    set(CPROJT_BUILD_TESTS ON)
endif()

# ----------------------------------------------------------------------------
# CMake options
# ----------------------------------------------------------------------------
if(is_main_project)
    if(NOT CMAKE_BUILD_TYPE)
        set(default_build_type Debug)
        message(STATUS "No build type specified, setting it to '${default_build_type}'")
        set(CMAKE_BUILD_TYPE ${default_build_type})
    endif()

    # Generates a JSON file containing the exact compiler commands. Useful for clang-based tools.
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
endif()

# ----------------------------------------------------------------------------
# Dependencies
# ----------------------------------------------------------------------------
include(ProjectDependencies)
fetch_project_dependencies(${CPROJT_BUILD_TESTS})

# ----------------------------------------------------------------------------
# Compiler options
# ----------------------------------------------------------------------------
if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
endif()

# Disable compiler specific extensions.
set(CMAKE_CXX_EXTENSIONS OFF)

include(CompilerOptions)

set(compiler_options_library compile_options)
set(compilation_warnings_as_errors ${is_main_project})
set_project_default_compiler_options(
    ${compiler_options_library} ${CPROJT_PROJECT_NAME} ${compilation_warnings_as_errors}
)

# ----------------------------------------------------------------------------
# Quality tools
# ----------------------------------------------------------------------------
set(scripts_dir "${CMAKE_CURRENT_SOURCE_DIR}/scripts")
set(source_code_directories
    "${CMAKE_CURRENT_SOURCE_DIR}/examples" "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/src" "${CMAKE_CURRENT_SOURCE_DIR}/test"
)
set(cmake_directories "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

if(CPROJT_ENABLE_COVERAGE)
    include(CodeCoverage)
    set(coverage_exclude_patterns
        "/usr/include/*" "/usr/local/*" "*/_deps/*" "${CMAKE_CURRENT_SOURCE_DIR}/test/*"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
    )
    set(min_line_coverage 90)
    set(min_function_coverage 80)
    set(coverage_check_script "${scripts_dir}/coverage_report_checker.sh")
    enable_coverage(
        ${compiler_options_library} "${coverage_exclude_patterns}" ${min_line_coverage}
        ${min_function_coverage} ${coverage_check_script}
    )
endif()

if(CPROJT_ENABLE_CLANG_FORMAT)
    include(ClangFormat)
    set(log_file "clang-format-report.log")
    enable_clang_format("${source_code_directories}" ${log_file})
endif()

if(CPROJT_ENABLE_CLANG_TIDY)
    include(ClangTidy)
    set(log_file "clang-tidy-report.log")
    enable_clang_tidy("${source_code_directories}" ${log_file})
endif()

if(CPROJT_ENABLE_ASAN
   OR CPROJT_ENABLE_LSAN
   OR CPROJT_ENABLE_MSAN
   OR CPROJT_ENABLE_TSAN
   OR CPROJT_ENABLE_UBSAN
)
    include(Sanitizers)
    enable_sanitizers(
        ${compiler_options_library} ${CPROJT_ENABLE_ASAN} ${CPROJT_ENABLE_LSAN}
        ${CPROJT_ENABLE_MSAN} ${CPROJT_ENABLE_TSAN} ${CPROJT_ENABLE_UBSAN}
    )
endif()

if(CPROJT_ENABLE_DOXYGEN)
    include(DoxygenDoc)
    set(config_file "${CMAKE_CURRENT_SOURCE_DIR}/doxygen/Doxyfile.in")
    set(doxygen_project "C++ Project Template")
    set(doxygen_version ${CPROJT_PROJECT_VERSION})
    set(doxygen_brief "A C++ project template using CMake")
    set(input_list "${source_code_directories}")
    string(REPLACE ";" " " doxygen_input "${input_list}")
    set(doxygen_out_dir "${CMAKE_BINARY_DIR}/doxygen")
    set(log_file "doxygen-report.log")
    enable_doxygen_doc(
        ${config_file}
        ${doxygen_project}
        ${doxygen_version}
        ${doxygen_brief}
        ${doxygen_input}
        ${doxygen_out_dir}
        ${log_file}
    )
endif()

list(APPEND cmake_directories_to_check ${cmake_directories})
list(APPEND cmake_directories_to_check ${source_code_directories})
set(cmake_files_to_check "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt")

if(CPROJT_ENABLE_CMAKE_FORMAT)
    include(CmakeFormat)
    set(log_file "cmake-format-report.log")
    enable_cmake_format("${cmake_directories_to_check}" "${cmake_files_to_check}" ${log_file})
endif()

if(CPROJT_ENABLE_CMAKE_LINT)
    include(CmakeLint)
    set(log_file "cmake-lint-report.log")
    enable_cmake_lint("${cmake_directories_to_check}" "${cmake_files_to_check}" ${log_file})
endif()

# ----------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------
add_subdirectory(src)

if(CPROJT_BUILD_TESTS)
    include(CTest)
    include(GoogleTest)
    enable_testing()
    add_subdirectory(test)
endif()

# ----------------------------------------------------------------------------
# Configuration report
# ----------------------------------------------------------------------------
message(STATUS)
message(STATUS "${CPROJT_PROJECT_NAME} ${CPROJT_PROJECT_VERSION} configuration:")
message(STATUS "- CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
message(STATUS "- CMAKE_CXX_COMPILER_ID = ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "- CMAKE_CXX_COMPILER_VERSION = ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "- CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}")
message(STATUS "- CMAKE_EXPORT_COMPILE_COMMANDS = ${CMAKE_EXPORT_COMPILE_COMMANDS}")
message(STATUS "- CPROJT_BUILD_TESTS = ${CPROJT_BUILD_TESTS}")
message(STATUS "- CPROJT_ENABLE_COVERAGE = ${CPROJT_ENABLE_COVERAGE}")
message(STATUS "- CPROJT_ENABLE_CLANG_FORMAT = ${CPROJT_ENABLE_CLANG_FORMAT}")
message(STATUS "- CPROJT_ENABLE_CLANG_TIDY = ${CPROJT_ENABLE_CLANG_TIDY}")
message(STATUS "- CPROJT_ENABLE_ASAN = ${CPROJT_ENABLE_ASAN}")
message(STATUS "- CPROJT_ENABLE_LSAN = ${CPROJT_ENABLE_LSAN}")
message(STATUS "- CPROJT_ENABLE_MSAN = ${CPROJT_ENABLE_MSAN}")
message(STATUS "- CPROJT_ENABLE_TSAN = ${CPROJT_ENABLE_TSAN}")
message(STATUS "- CPROJT_ENABLE_UBSAN = ${CPROJT_ENABLE_UBSAN}")
message(STATUS "- CPROJT_ENABLE_DOXYGEN = ${CPROJT_ENABLE_DOXYGEN}")
message(STATUS "- CPROJT_ENABLE_CMAKE_FORMAT = ${CPROJT_ENABLE_CMAKE_FORMAT}")
message(STATUS "- CPROJT_ENABLE_CMAKE_LINT = ${CPROJT_ENABLE_CMAKE_LINT}")
message(STATUS "- is_main_project = ${is_main_project}")
message(STATUS)
