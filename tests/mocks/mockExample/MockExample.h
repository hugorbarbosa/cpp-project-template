/**
 * @file
 * @copyright Copyright (c) 2022.
 */

#pragma once

#include <gmock/gmock.h>

namespace projTemplate {
namespace tests {
namespace mocks {
namespace mockExample {

/**
 * @brief Mock of the Example.
 *
 * This mock is not used. It just serves as an example of how to use GMock.
 */
class MockExample : public Example
{
public:
    /** Mock method exampleMethod. */
    MOCK_METHOD(void, exampleMethod, (), (override));
};

} // namespace mockExample
} // namespace mocks
} // namespace tests
} // namespace projTemplate
