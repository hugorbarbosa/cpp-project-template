/**
 * @file
 * @copyright Copyright (C) 2022-2025 Hugo Barbosa.
 */

#include <iostream>
#include <memory>
#include <my_concrete_class.hpp>
#include "git_info.hpp"
#include "version.hpp"

/**
 * @brief Main function.
 *
 * @param argc Number of command line arguments.
 * @param argv Command line arguments.
 *
 * @return Program exit code.
 */
int main([[maybe_unused]] int argc, [[maybe_unused]] char* argv[])
{
    std::cout << "Hello World!\n";

    std::cout << "Project information:\n"
              << "- Project version: " << cpp_project_template::get_project_version() << "\n"
              << "- Git branch: " << cpp_project_template::project_git_branch << "\n"
              << "- Git commit hash: " << cpp_project_template::project_git_commit_hash << "\n";

    std::unique_ptr<cpp_project_template::MyClass> my_class{
        std::make_unique<cpp_project_template::MyConcreteClass>("Initial value")};

    constexpr auto print_class_value
        = [](const auto& value) { std::cout << "My class value = " << value << "\n"; };

    print_class_value(my_class->get_value());

    my_class->set_value("New value 1");
    print_class_value(my_class->get_value());

    my_class->set_value("New value 2");
    print_class_value(my_class->get_value());

    return EXIT_SUCCESS;
}
