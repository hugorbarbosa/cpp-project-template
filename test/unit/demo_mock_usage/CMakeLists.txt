set(target_name "ut_demo_mock_usage")
add_executable(${target_name})

target_sources(${target_name} PRIVATE ut_demo_mock_usage.cpp)

target_link_libraries(
    ${target_name} PRIVATE GTest::gtest_main ${CPROJT_PROJECT_NAME}::compile_options
                           ${CPROJT_PROJECT_NAME}::mock_my_class
)

gtest_discover_tests(${target_name})
