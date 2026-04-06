/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <mock_my_class.hpp>
#include <my_class.hpp>

using cpp_project_template::my_class;

/**
 * @brief Class that uses the mock of my class, to demonstrate how to use a mock in tests.
 *
 * This class exemplifies an entity that uses my class in the implementation code (it would not be
 * here in a "real" project).
 */
class demo_mock_usage {
public:
    /**
     * @brief Constructor.
     *
     * @param my_cl My class.
     */
    explicit demo_mock_usage(std::shared_ptr<my_class> my_cl)
        : class_example{std::move(my_cl)}
    {
    }

    /**
     * @brief Set my class value.
     *
     * @param value Value to set.
     */
    void set_my_class_value(std::string value) noexcept
    {
        class_example->set_value(std::move(value));
    }

    /**
     * @brief Get my class value.
     *
     * @return My class value.
     */
    std::string get_my_class_value() const noexcept
    {
        return class_example->get_value();
    }

private:
    /// My class.
    std::shared_ptr<my_class> class_example;
};

/**
 * @brief Unit testing suite to demonstrate how to use a mock in tests.
 */
class ut_demo_mock_usage : public testing::Test {
protected:
    /**
     * @brief Constructor.
     */
    ut_demo_mock_usage()
        : mock_my_class{std::make_shared<cpp_project_template::test::mock_my_class>()}
    {
    }

    // Clang-tidy suppression.
    // Rationale: Test fixtures are meant to expose data to the test cases.
    // NOLINTBEGIN(cppcoreguidelines-non-private-member-variables-in-classes)

    /// Mock of my class.
    std::shared_ptr<cpp_project_template::test::mock_my_class> mock_my_class;

    // NOLINTEND(cppcoreguidelines-non-private-member-variables-in-classes)
};

/**
 * @brief Test that the mock of my class is notified to set a value.
 */
TEST_F(ut_demo_mock_usage, value_is_set_through_my_class)
{
    constexpr auto value = "Value";

    EXPECT_CALL(*mock_my_class, set_value(value)).Times(1);

    demo_mock_usage mock_usage{mock_my_class};
    mock_usage.set_my_class_value(value);
}

/**
 * @brief Test that the mock of my class is notified to get a value.
 */
TEST_F(ut_demo_mock_usage, value_is_retrieved_through_my_class)
{
    constexpr auto value = "Value";

    EXPECT_CALL(*mock_my_class, get_value).WillOnce(testing::Return(value));

    const demo_mock_usage mock_usage{mock_my_class};
    EXPECT_EQ(mock_usage.get_my_class_value(), value);
}
