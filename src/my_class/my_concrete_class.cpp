/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include "my_concrete_class.hpp"

namespace cpp_project_template {

MyConcreteClass::MyConcreteClass(std::string value) noexcept
    : my_value{std::move(value)}
{
}

void MyConcreteClass::set_value(std::string value) noexcept
{
    my_value = std::move(value);
}

std::string MyConcreteClass::get_value() const noexcept
{
    return my_value;
}

} // namespace cpp_project_template
