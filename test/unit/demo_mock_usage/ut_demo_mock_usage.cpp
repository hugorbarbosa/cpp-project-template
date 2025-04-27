/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <mock_my_class.hpp>
#include <my_class.hpp>

using cpp_project_template::MyClass;

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
     * @param my_cl My class.
     */
    explicit DemoMockUsage(std::shared_ptr<MyClass> my_cl)
        : my_class{std::move(my_cl)}
    {
    }

    /**
     * @brief Set my class value.
     *
     * @param value Value to set.
     */
    void set_my_class_value(std::string value) noexcept
    {
        my_class->set_value(std::move(value));
    }

    /**
     * @brief Get my class value.
     *
     * @return My class value.
     */
    std::string get_my_class_value() const noexcept
    {
        return my_class->get_value();
    }

private:
    /// My class.
    std::shared_ptr<MyClass> my_class;
};

/**
 * @brief Unit testing suite to demonstrate how to use a mock in tests.
 */
class UtDemoMockUsage : public testing::Test {
protected:
    /**
     * @brief Get an instance of the mock of my class.
     *
     * @return Instance of the mock of my class.
     */
    static auto get_mock_my_class() noexcept
    {
        return std::make_shared<cpp_project_template::test::MockMyClass>();
    }
};

/**
 * @brief Test that the mock of my class is notified to set a value.
 */
TEST_F(UtDemoMockUsage, ValueIsDefinedThroughMyClass)
{
    constexpr auto value = "Value";

    const auto mock_my_class = get_mock_my_class();
    EXPECT_CALL(*mock_my_class, set_value(value)).Times(1);

    DemoMockUsage demo_mock_usage{mock_my_class};
    demo_mock_usage.set_my_class_value(value);
}

/**
 * @brief Test that the mock of my class is notified to get a value.
 */
TEST_F(UtDemoMockUsage, ValueIsRetrievedThroughMyClass)
{
    constexpr auto value = "Value";

    const auto mock_my_class = get_mock_my_class();
    EXPECT_CALL(*mock_my_class, get_value).WillOnce(testing::Return(value));

    const DemoMockUsage demo_mock_usage{mock_my_class};
    EXPECT_EQ(demo_mock_usage.get_my_class_value(), value);
}
