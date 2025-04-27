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
class MyClass {
public:
    /**
     * @brief Destructor.
     */
    virtual ~MyClass() = default;

    /**
     * @brief Constructor.
     */
    MyClass() = default;

    /**
     * @brief Copy constructor.
     */
    MyClass(const MyClass&) = delete;

    /**
     * @brief Copy assignment operator.
     */
    MyClass& operator=(const MyClass&) = delete;

    /**
     * @brief Move constructor.
     */
    MyClass(MyClass&&) = delete;

    /**
     * @brief Move assignment operator.
     */
    MyClass& operator=(MyClass&&) = delete;

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
