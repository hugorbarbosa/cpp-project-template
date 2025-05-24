/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#include <gtest/gtest.h>
#include <version.hpp>

/**
 * @brief Test that the project version is correctly constructed.
 */
TEST(UtProjectVersion, ProjectVersionIsCorrect)
{
    const auto project_version = cpp_project_template::get_project_version();
    const auto expected_project_version
        = std::to_string(cpp_project_template::project_version_major) + '.'
          + std::to_string(cpp_project_template::project_version_minor) + '.'
          + std::to_string(cpp_project_template::project_version_patch)
          + (!cpp_project_template::project_version_prerelease.empty()
                 ? ('-' + std::string{cpp_project_template::project_version_prerelease})
                 : "");
    EXPECT_EQ(project_version, expected_project_version);
}
