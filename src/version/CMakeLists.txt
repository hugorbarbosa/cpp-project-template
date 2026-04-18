set(target_name "version")
add_library(${target_name} INTERFACE)
add_library(${CPROJT_PROJECT_NAME}::${target_name} ALIAS ${target_name})

target_sources(${target_name} PUBLIC FILE_SET HEADERS)

target_link_libraries(${target_name} INTERFACE ${CPROJT_PROJECT_NAME}::compile_options)
