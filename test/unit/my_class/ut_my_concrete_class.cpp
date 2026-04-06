/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <my_concrete_class.hpp>

using cpp_project_template::my_concrete_class;

/**
 * @brief Test that the value can be correctly updated.
 *
 * It serves as an example of a test without a Test Fixture.
 */
TEST(ut_my_concrete_class_without_fixture, value_is_defined)
{
    my_concrete_class concrete_class{""};

    constexpr auto value = "Value";
    concrete_class.set_value(value);
    EXPECT_EQ(concrete_class.get_value(), value);
}

/**
 * @brief Unit testing suite of my concrete class.
 *
 * It serves as an example of a Test Fixture.
 */
class ut_my_concrete_class : public testing::Test {
protected:
    /// Default value of my concrete class used for testing.
    static constexpr auto default_value = "Initial value";

    /**
     * @brief Constructor.
     *
     * You can do set-up work for each test here.
     *
     * @note Remove it if its body is empty. In this case it is for demonstration purposes only.
     */
    ut_my_concrete_class() = default;

    /**
     * @brief Test fixture setup.
     *
     * If the constructor is not enough, this function can be used for setting up each test.
     * Code here will be called immediately after the constructor (right before each test).
     *
     * @note Remove it if its body is empty. In this case it is for demonstration purposes only.
     */
    void SetUp() override {}

    /**
     * @brief Test fixture teardown.
     *
     * A class destructor can be defined to clean-up work that doesn't throw exceptions. However, if
     * the destructor is not enough, this function can be used for cleaning up each test.
     * Code here will be called immediately after each test (right before the destructor).
     *
     * @note Remove it if its body is empty. In this case it is for demonstration purposes only.
     */
    void TearDown() override {}

    // Class members declared here can be used by all tests of this test suite.
};

/**
 * @brief Test that the initial value is correctly defined.
 */
TEST_F(ut_my_concrete_class, initial_value_is_defined)
{
    const my_concrete_class concrete_class_1{default_value};
    ASSERT_EQ(concrete_class_1.get_value(), default_value);

    constexpr auto local_initial_value = "Local initial value";
    const my_concrete_class concrete_class_2{local_initial_value};
    EXPECT_EQ(concrete_class_2.get_value(), local_initial_value);
}

/**
 * @brief Test that the value can be correctly updated.
 */
TEST_F(ut_my_concrete_class, value_can_be_updated)
{
    constexpr auto value1 = "Value 1";

    my_concrete_class concrete_class{default_value};
    concrete_class.set_value(value1);
    ASSERT_EQ(concrete_class.get_value(), value1);

    constexpr auto value2 = "Value 2";
    concrete_class.set_value(value2);
    EXPECT_EQ(concrete_class.get_value(), value2);
}

/**
 * @brief Parameterized test fixture of my concrete class.
 *
 * It serves as an example of how to write value-parameterized tests.
 */
class param_test_my_concrete_class
    : public ut_my_concrete_class
    , public testing::WithParamInterface<std::string> {};

/**
 * @brief Instantiation of the parameterized test fixture of my concrete class.
 */
INSTANTIATE_TEST_SUITE_P(set_value,
                         param_test_my_concrete_class,
                         testing::Values("value1", "value2", "value3", "value4"));

/**
 * @brief Test that the value can be correctly updated.
 */
TEST_P(param_test_my_concrete_class, value_can_be_updated)
{
    const auto& value = GetParam();

    my_concrete_class concrete_class{default_value};
    concrete_class.set_value(value);
    EXPECT_EQ(concrete_class.get_value(), value);
}
