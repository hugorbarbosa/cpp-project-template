/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include "my_concrete_class.hpp"

namespace cpp_project_template {

my_concrete_class::my_concrete_class(std::string value) noexcept
    : my_value{std::move(value)}
{
}

void my_concrete_class::set_value(std::string value) noexcept
{
    my_value = std::move(value);
}

std::string my_concrete_class::get_value() const noexcept
{
    return my_value;
}

} // namespace cpp_project_template
