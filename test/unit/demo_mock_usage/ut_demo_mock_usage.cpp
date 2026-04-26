/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <mock_my_class.hpp>
#include <my_class.hpp>

using cpp_project_template::MyClass;
using cpp_project_template::test::MockMyClass;

/**
 * @brief Class that uses the mock of my class, to demonstrate how to use a mock in tests.
 *
 * This class exemplifies an entity that uses my class in the implementation code (it would not be
 * here in a "real" project).
 */
class DemoMockUsage {
public:
    /**
     * @brief Constructor.
     *
     * @param my_class My class.
     */
    explicit DemoMockUsage(std::shared_ptr<MyClass> my_class)
        : my_class_{std::move(my_class)}
    {
    }

    /**
     * @brief Set my class value.
     *
     * @param value Value to set.
     */
    void set_my_class_value(std::string value) noexcept
    {
        my_class_->set_value(std::move(value));
    }

    /**
     * @brief Get my class value.
     *
     * @return My class value.
     */
    std::string get_my_class_value() const noexcept
    {
        return my_class_->get_value();
    }

private:
    /// My class.
    std::shared_ptr<MyClass> my_class_;
};

/**
 * @brief Unit testing suite to demonstrate how to use a mock in tests.
 */
class UtDemoMockUsage : public testing::Test {
protected:
    /**
     * @brief Constructor.
     */
    UtDemoMockUsage()
        : mock_my_class_{std::make_shared<MockMyClass>()}
    {
    }

    // Clang-tidy suppression.
    // Rationale: Test fixtures are meant to expose data to the test cases.
    // NOLINTBEGIN(cppcoreguidelines-non-private-member-variables-in-classes)

    /// Mock of my class.
    std::shared_ptr<MockMyClass> mock_my_class_;

    // NOLINTEND(cppcoreguidelines-non-private-member-variables-in-classes)
};

/**
 * @brief Test that the mock of my class is notified to set a value.
 */
TEST_F(UtDemoMockUsage, ValueIsSetThroughMyClass)
{
    constexpr auto value = "Value";

    EXPECT_CALL(*mock_my_class_, set_value(value)).Times(1);

    DemoMockUsage demo_mock_usage{mock_my_class_};
    demo_mock_usage.set_my_class_value(value);
}

/**
 * @brief Test that the mock of my class is notified to get a value.
 */
TEST_F(UtDemoMockUsage, ValueIsRetrievedThroughMyClass)
{
    constexpr auto value = "Value";

    EXPECT_CALL(*mock_my_class_, get_value).WillOnce(testing::Return(value));

    const DemoMockUsage demo_mock_usage{mock_my_class_};
    EXPECT_EQ(demo_mock_usage.get_my_class_value(), value);
}
