project(cpp-project-template)

add_subdirectory(my_class)
add_subdirectory(version)

add_executable(${PROJECT_NAME} main.cpp)

target_include_git_info_directory(${PROJECT_NAME})

target_link_libraries(
    ${PROJECT_NAME} PRIVATE ${CPROJT_PROJECT_NAME}::compile_options ${CPROJT_PROJECT_NAME}::version
                            ${CPROJT_PROJECT_NAME}::my_class
)

set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
