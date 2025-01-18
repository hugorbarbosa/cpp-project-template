project(mock_my_class)

add_library(${PROJECT_NAME} INTERFACE)
add_library(${CPP_PROJECT_TEMPLATE_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
    INTERFACE .
)

target_link_libraries(${PROJECT_NAME}
    INTERFACE GTest::gmock
    INTERFACE ${CPP_PROJECT_TEMPLATE_NAME}::my_class
)
