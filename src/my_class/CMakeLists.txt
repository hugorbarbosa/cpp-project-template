set(target_name "my_class")
add_library(${target_name} STATIC)
add_library(${CPROJT_PROJECT_NAME}::${target_name} ALIAS ${target_name})

target_sources(
    ${target_name}
    PRIVATE my_concrete_class.cpp
    PUBLIC FILE_SET HEADERS
)

target_link_libraries(${target_name} PRIVATE ${CPROJT_PROJECT_NAME}::compile_options)
