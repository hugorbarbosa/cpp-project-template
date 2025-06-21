/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <my_concrete_class.hpp>

using cpp_project_template::MyConcreteClass;

/**
 * @brief Test that the value can be correctly updated.
 *
 * It serves as an example of a test without a Test Fixture.
 */
TEST(UtMyConcreteClassWithoutFixture, ValueIsDefined)
{
    MyConcreteClass my_concrete_class{""};

    constexpr auto value = "Value";
    my_concrete_class.set_value(value);
    EXPECT_EQ(my_concrete_class.get_value(), value);
}

/**
 * @brief Unit testing suite of my concrete class.
 *
 * It serves as an example of a Test Fixture.
 */
class UtMyConcreteClass : public testing::Test {
protected:
    /// Default value of my concrete class used for testing.
    static constexpr auto default_value = "Initial value";

    // You can remove any or all of the following functions if their bodies would be empty.

    /**
     * @brief Constructor.
     *
     * You can do set-up work for each test here.
     */
    UtMyConcreteClass() = default;

    /**
     * @brief Test fixture setup.
     *
     * If the constructor is not enough, this function can be used for setting up each test.
     * Code here will be called immediately after the constructor (right before each test).
     */
    void SetUp() override {}

    /**
     * @brief Test fixture teardown.
     *
     * A class destructor can be defined to clean-up work that doesn't throw exceptions. However, if
     * the destructor is not enough, this function can be used for cleaning up each test.
     * Code here will be called immediately after each test (right before the destructor).
     */
    void TearDown() override {}

    // Class members declared here can be used by all tests of this test suite.
};

/**
 * @brief Test that the initial value is correctly defined.
 */
TEST_F(UtMyConcreteClass, InitialValueIsDefined)
{
    const MyConcreteClass my_concrete_class{default_value};
    ASSERT_EQ(my_concrete_class.get_value(), default_value);

    constexpr auto local_initial_value = "Local initial value";
    const MyConcreteClass my_concrete_class_local{local_initial_value};
    EXPECT_EQ(my_concrete_class_local.get_value(), local_initial_value);
}

/**
 * @brief Test that the value can be correctly updated.
 */
TEST_F(UtMyConcreteClass, ValueCanBeUpdated)
{
    constexpr auto value1 = "Value 1";

    MyConcreteClass my_concrete_class{default_value};
    my_concrete_class.set_value(value1);
    ASSERT_EQ(my_concrete_class.get_value(), value1);

    constexpr auto value2 = "Value 2";
    my_concrete_class.set_value(value2);
    EXPECT_EQ(my_concrete_class.get_value(), value2);
}

/**
 * @brief Parameterized test fixture of my concrete class.
 *
 * It serves as an example of how to write value-parameterized tests.
 */
class ParamTestMyConcreteClass
    : public UtMyConcreteClass
    , public testing::WithParamInterface<std::string> {};

/**
 * @brief Instantiation of the parameterized test fixture of my concrete class.
 */
INSTANTIATE_TEST_SUITE_P(SetValue,
                         ParamTestMyConcreteClass,
                         testing::Values("value1", "value2", "value3", "value4"));

/**
 * @brief Test that the value can be correctly updated.
 */
TEST_P(ParamTestMyConcreteClass, ValueCanBeUpdated)
{
    const auto& value = GetParam();

    MyConcreteClass my_concrete_class{default_value};
    my_concrete_class.set_value(value);
    EXPECT_EQ(my_concrete_class.get_value(), value);
}
