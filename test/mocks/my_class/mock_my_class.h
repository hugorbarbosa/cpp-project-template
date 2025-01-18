/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#ifndef CPP_PROJECT_TEMPLATE_MOCK_MY_CLASS_H
#define CPP_PROJECT_TEMPLATE_MOCK_MY_CLASS_H

#include <gmock/gmock.h>
#include <my_class.h>

namespace cpp_project_template {
namespace test {

/**
 * @brief Mock of my class.
 */
class MockMyClass : public MyClass {
public:
    /// Mock of set_value.
    MOCK_METHOD(void, set_value, (std::string), (noexcept, override));

    /// Mock of get_value.
    MOCK_METHOD(std::string, get_value, (), (const, noexcept, override));
};

} // namespace test
} // namespace cpp_project_template

#endif // CPP_PROJECT_TEMPLATE_MOCK_MY_CLASS_H
