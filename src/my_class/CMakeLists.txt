project(my_class)

add_library(${PROJECT_NAME} STATIC
    my_concrete_class.cpp
)
add_library(${CPP_PROJECT_TEMPLATE_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
    PUBLIC .
)
