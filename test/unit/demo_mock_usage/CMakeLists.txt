project(ut_demo_mock_usage)

add_executable(${PROJECT_NAME} ut_demo_mock_usage.cpp)

gtest_discover_tests(${PROJECT_NAME})

target_link_libraries(
    ${PROJECT_NAME} PRIVATE GTest::gtest_main ${CPROJT_PROJECT_NAME}::compile_options
                            ${CPROJT_PROJECT_NAME}::mock_my_class
)
