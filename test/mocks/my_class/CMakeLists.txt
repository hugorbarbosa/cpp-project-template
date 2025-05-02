project(mock_my_class)

add_library(${PROJECT_NAME} INTERFACE)
add_library(${CXXPROJT_PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
    INTERFACE .
)

target_link_libraries(${PROJECT_NAME}
    INTERFACE ${CXXPROJT_PROJECT_NAME}::compile_options
    INTERFACE GTest::gmock
    INTERFACE ${CXXPROJT_PROJECT_NAME}::my_class
)
