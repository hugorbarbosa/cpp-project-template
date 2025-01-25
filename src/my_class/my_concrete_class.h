/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#ifndef CPP_PROJECT_TEMPLATE_MY_CONCRETE_CLASS_H
#define CPP_PROJECT_TEMPLATE_MY_CONCRETE_CLASS_H

#include "my_class.h"

namespace cpp_project_template {

/**
 * @brief My concrete class.
 *
 * This is just an example of a derived class.
 */
class MyConcreteClass : public MyClass {
public:
    /**
     * @brief Constructor.
     *
     * @param value Initial value.
     */
    explicit MyConcreteClass(std::string value) noexcept;

    /**
     * @copydoc MyClass#set_value
     */
    void set_value(std::string value) noexcept override;

    /**
     * @copydoc MyClass#get_value
     */
    std::string get_value() const noexcept override;

private:
    /// Value.
    std::string my_value;
};

} // namespace cpp_project_template

#endif // CPP_PROJECT_TEMPLATE_MY_CONCRETE_CLASS_H
