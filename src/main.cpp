/**
 * @file
 * @copyright Copyright (c) 2022.
 */

#include <adder/Adder.h>
#include <iostream>

/**
 * @brief Main function.
 *
 * @param argc Number of command line arguments.
 * @param argv Command line arguments.
 *
 * @return Program exit code.
 */
int main([[maybe_unused]] int argc, [[maybe_unused]] char const* argv[])
{
    std::cout << "Hello World!" << std::endl;

    constexpr auto num1{1};
    constexpr auto num2{2};
    std::cout << "Addition: " << num1 << " + " << num2 << " = " << projectTemplate::adder::add(num1, num2) << std::endl;

    return EXIT_SUCCESS;
}
