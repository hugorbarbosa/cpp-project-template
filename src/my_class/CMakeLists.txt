project(my_class)

add_library(${PROJECT_NAME} STATIC my_concrete_class.cpp)
add_library(${CPROJT_PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} PUBLIC .)

target_link_libraries(${PROJECT_NAME} PRIVATE ${CPROJT_PROJECT_NAME}::compile_options)
