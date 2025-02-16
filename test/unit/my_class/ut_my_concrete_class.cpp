/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <my_concrete_class.hpp>

using namespace testing;
using namespace cpp_project_template;

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
 * @brief Unit testing of my concrete class.
 *
 * It serves as an example of a Test Fixture.
 */
class UtMyConcreteClass : public Test {
protected:
    /// Default value of my concrete class used for testing.
    static constexpr auto default_value = "Initial value";

    // You can remove any or all of the following functions if their bodies would be empty.

    /**
     * @brief Constructor.
     *
     * You can do set-up work for each test here.
     */
    UtMyConcreteClass()
        : my_concrete_class{default_value}
    {
    }

    /**
     * @brief Destructor.
     *
     * You can do clean-up work that doesn't throw exceptions here.
     */
    ~UtMyConcreteClass() override {}

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
     * If the destructor is not enough, this function can be used for cleaning up each test.
     * Code here will be called immediately after each test (right before the destructor).
     */
    void TearDown() override {}

    /// My concrete class under testing.
    MyConcreteClass my_concrete_class;
};

/**
 * @brief Test that the initial value is correctly defined.
 */
TEST_F(UtMyConcreteClass, InitialValueIsDefined)
{
    ASSERT_EQ(my_concrete_class.get_value(), default_value);

    constexpr auto local_initial_value = "Local initial value";
    MyConcreteClass my_concrete_class_local{local_initial_value};
    EXPECT_EQ(my_concrete_class_local.get_value(), local_initial_value);
}

/**
 * @brief Test that the value can be correctly updated.
 */
TEST_F(UtMyConcreteClass, ValueCanBeUpdated)
{
    constexpr auto value1 = "Value 1";
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
    , public WithParamInterface<std::string> {
};

/**
 * @brief Test that the value can be correctly updated.
 */
TEST_P(ParamTestMyConcreteClass, ValueCanBeUpdated)
{
    const auto& value = GetParam();
    my_concrete_class.set_value(value);
    EXPECT_EQ(my_concrete_class.get_value(), value);
}

/**
 * @brief Instantiation of the parameterized test fixture of my concrete class.
 */
INSTANTIATE_TEST_SUITE_P(SetValue,
                         ParamTestMyConcreteClass,
                         Values("value1", "value2", "value3", "value4"));
