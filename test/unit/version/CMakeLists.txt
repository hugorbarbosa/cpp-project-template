project(ut_version)

add_executable(${PROJECT_NAME}
    ut_version.cpp
)

gtest_discover_tests(${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME}
    PRIVATE ${CXXPROJT_PROJECT_NAME}::compile_options
    PRIVATE GTest::gtest_main
    PRIVATE ${CXXPROJT_PROJECT_NAME}::version
)
