/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#ifndef CPP_PROJECT_TEMPLATE_MY_CLASS_HPP
#define CPP_PROJECT_TEMPLATE_MY_CLASS_HPP

#include <string>

namespace cpp_project_template {

/**
 * @brief My class.
 *
 * This is just an example of a base class.
 */
class my_class {
public:
    /**
     * @brief Destructor.
     */
    virtual ~my_class() = default;

    /**
     * @brief Constructor.
     */
    my_class() = default;

    /**
     * @brief Copy constructor.
     */
    my_class(const my_class&) = delete;

    /**
     * @brief Copy assignment operator.
     */
    my_class& operator=(const my_class&) = delete;

    /**
     * @brief Move constructor.
     */
    my_class(my_class&&) = delete;

    /**
     * @brief Move assignment operator.
     */
    my_class& operator=(my_class&&) = delete;

    /**
     * @brief Set value.
     *
     * @param value New value to set.
     */
    virtual void set_value(std::string value) noexcept = 0;

    /**
     * @brief Get value.
     *
     * @return Value.
     */
    virtual std::string get_value() const noexcept = 0;
};

} // namespace cpp_project_template

#endif // CPP_PROJECT_TEMPLATE_MY_CLASS_HPP
