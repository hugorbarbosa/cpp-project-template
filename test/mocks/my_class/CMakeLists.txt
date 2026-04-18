set(target_name "mock_my_class")
add_library(${target_name} INTERFACE)
add_library(${CPROJT_PROJECT_NAME}::${target_name} ALIAS ${target_name})

target_sources(${target_name} INTERFACE FILE_SET HEADERS)

target_link_libraries(
    ${target_name} INTERFACE GTest::gmock ${CPROJT_PROJECT_NAME}::compile_options
                             ${CPROJT_PROJECT_NAME}::my_class
)
