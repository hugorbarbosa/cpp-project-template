project(ut_my_class)

add_executable(${PROJECT_NAME} ut_my_concrete_class.cpp)

gtest_discover_tests(${PROJECT_NAME})

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE ${CPROJT_PROJECT_NAME}::compile_options
    PRIVATE GTest::gtest_main
    PRIVATE ${CPROJT_PROJECT_NAME}::my_class
)
