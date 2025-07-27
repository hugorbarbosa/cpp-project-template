project(version)

add_library(${PROJECT_NAME} INTERFACE)
add_library(${CPROJT_PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} INTERFACE .)

target_link_libraries(${PROJECT_NAME} INTERFACE ${CPROJT_PROJECT_NAME}::compile_options)
