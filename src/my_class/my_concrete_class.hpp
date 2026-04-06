/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#ifndef CPP_PROJECT_TEMPLATE_MY_CONCRETE_CLASS_HPP
#define CPP_PROJECT_TEMPLATE_MY_CONCRETE_CLASS_HPP

#include "my_class.hpp"

namespace cpp_project_template {

/**
 * @brief My concrete class.
 *
 * This is just an example of a derived class.
 */
class my_concrete_class : public my_class {
public:
    /**
     * @brief Constructor.
     *
     * @param value Initial value.
     */
    explicit my_concrete_class(std::string value) noexcept;

    /**
     * @copydoc my_class::set_value
     */
    void set_value(std::string value) noexcept override;

    /**
     * @copydoc my_class::get_value
     */
    std::string get_value() const noexcept override;

private:
    /// Value.
    std::string my_value;
};

} // namespace cpp_project_template

#endif // CPP_PROJECT_TEMPLATE_MY_CONCRETE_CLASS_HPP
