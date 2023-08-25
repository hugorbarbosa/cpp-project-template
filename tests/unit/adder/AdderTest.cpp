/**
 * @file
 * @copyright Copyright (c) 2022.
 */

#include <Adder.h>
#include <gtest/gtest.h>

using namespace testing;
using namespace projectTemplate;

/**
 * @brief Test that the addition is correctly performed.
 */
TEST(AdderTest, AdditionSuccess)
{
    constexpr auto num1 = 1;
    constexpr auto num2 = 2;

    // Expectations
    constexpr auto expectedRes = num1 + num2;
    EXPECT_EQ(adder::add(num1, num2), expectedRes);
}
