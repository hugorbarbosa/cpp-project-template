/**
 * @file
 * @copyright Copyright (C) 2025 Hugo Barbosa.
 */

#ifndef CPP_PROJECT_TEMPLATE_VERSION_HPP
#define CPP_PROJECT_TEMPLATE_VERSION_HPP

#include <string>

namespace cpp_project_template {

/// Major version.
inline constexpr auto project_version_major = 1;
/// Minor version.
inline constexpr auto project_version_minor = 2;
/// Patch version.
inline constexpr auto project_version_patch = 3;
/// Optional prerelease version (set as "" if not needed).
inline constexpr std::string_view project_version_prerelease = "rc1";

/**
 * @brief Get the project version as string.
 *
 * @return Project version.
 */
inline auto get_project_version() noexcept
{
    auto version = std::to_string(project_version_major) + '.'
                   + std::to_string(project_version_minor) + '.'
                   + std::to_string(project_version_patch);
    if (!project_version_prerelease.empty()) {
        version += '-' + std::string{project_version_prerelease};
    }
    return version;
}

} // namespace cpp_project_template

#endif // CPP_PROJECT_TEMPLATE_VERSION_HPP
