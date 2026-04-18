add_subdirectory(my_class)
add_subdirectory(version)

set(target_name "cpp-project-template")
add_executable(${target_name})

target_sources(${target_name} PRIVATE main.cpp)

target_include_git_info_directory(${target_name})

target_link_libraries(
    ${target_name} PRIVATE ${CPROJT_PROJECT_NAME}::compile_options ${CPROJT_PROJECT_NAME}::version
                           ${CPROJT_PROJECT_NAME}::my_class
)

set_target_properties(${target_name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
