/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include "my_concrete_class.hpp"

namespace cpp_project_template {

MyConcreteClass::MyConcreteClass(std::string value) noexcept
    : value_{std::move(value)}
{
}

void MyConcreteClass::set_value(std::string value) noexcept
{
    value_ = std::move(value);
}

std::string MyConcreteClass::get_value() const noexcept
{
    return value_;
}

} // namespace cpp_project_template
