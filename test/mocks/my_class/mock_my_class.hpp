/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#ifndef CPP_PROJECT_TEMPLATE_MOCK_MY_CLASS_HPP
#define CPP_PROJECT_TEMPLATE_MOCK_MY_CLASS_HPP

#include <gmock/gmock.h>
#include <my_class.hpp>

namespace cpp_project_template {
namespace test {

/**
 * @brief Mock of my class.
 */
class MockMyClass : public MyClass {
public:
    // Clang-tidy suppression.
    // Rationale: The exception warning is related to GoogleTest macro expansion code.
    // NOLINTBEGIN(bugprone-exception-escape)

    /// Mocked function.
    MOCK_METHOD(void, set_value, (std::string), (noexcept, override));

    /// Mocked function.
    MOCK_METHOD(std::string, get_value, (), (const, noexcept, override));

    // NOLINTEND(bugprone-exception-escape)
};

} // namespace test
} // namespace cpp_project_template

#endif // CPP_PROJECT_TEMPLATE_MOCK_MY_CLASS_HPP
