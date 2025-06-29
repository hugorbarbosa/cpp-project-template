# C++ project template

This project provides a comprehensive C++ project template, designed to help you quickly get started with a C++ project.

It offers a clear project structure, essential configurations, and integrates code quality tools to ensure clean, maintainable code right from the start.

## Table of contents

- [Features](#features)
- [Getting started](#getting-started)
- [Project structure](#project-structure)
- [Documentation](#documentation)
- [Building](#building)
- [Examples](#examples)
- [Integration](#integration)
- [Contributing to the project](#contributing-to-the-project)
- [Future work](#future-work)
- [License](#license)

## Features

- Build system setup using CMake.
- Modern CMake configuration that adheres to best practices, based on my knowledge and experience.
- Standard directory structure for easy navigation and scalability.
- Structure for any type of project, including header-only libraries.
- Separation of application/library code from test code to maintain a clean and modular project structure.
- Sample code files to quickly prototype and test.
- Examples of test suites and mocks.
- Integration of code quality tools for:
    - Code coverage.
    - Code formatting.
    - Static analysis.
    - Sanitizers.
    - Generation of documentation.
- Code quality tools configured to be easily executed and ready for integration into CI/CD pipelines.
- CI setup, using GitHub Actions, to build the project and run the tests on different operating systems and with different compilers. Additionally, the code quality tools used by this project are also executed in CI.
- Automatic dependency fetching, using CMake, for easy integration of third-party libraries.
- Templates for README, BUILDING and CONTRIBUTING documents.
- Example of a Dockerfile and how to use it.

## Getting started

This project template might contain some directories and files that are not needed for specific projects, so it should be adjusted to your needs.

The following procedure will help you to get started with this template:

- Get a copy of this template.
- Adjust the `CMakeLists` files to use your project files.
- Update prefix on the name of some CMake variables (`CXXPROJT_`) to use your project name.
- Remove unused files and directories.
- Update include guards on header files.
- Adjust copyrights in files.
- Replace the license file with the one specific to your project.
- Adjust clang-format, clang-tidy, and doxygen configuration files, as well as some of its parameters automatically configured by CMake.
- Update the `CMakePresets.json` file (e.g., CMake variables defined there).
- `Dockerfile` might be adjusted to your needs.
- Update this README to have only the sections that make sense for your project.
- Adjust the BUILDING and CONTRIBUTING guides to your needs.

## Project structure

This project template is structured in the following directories:

- `cmake`: useful CMake files.
- `doc`: project documentation.
- `docker`: `Dockerfile` example and a guide.
- `doxygen`: configuration used to build documentation from the source code using Doxygen.
- `examples`: examples of how to use the library.
- `external`: external dependencies of the project.
- `include`: public header files.
- `scripts`: useful scripts.
- `src`: source code of the project.
- `test`: files related with tests.
- `tools`: tools used by the project.

## Documentation

This section could describe the documentation available in the [`doc`](./doc/) directory, and eventually some links with information related to the project.

Using this project as example, the following is what this section could have:

"Documentation of this project is available in [`doc`](./doc/), and includes the following:

- Description of some examples of what can be inserted as documentation of a project (architecture diagrams, user guides, etc).
- Details about some code quality tools used by this project."

## Building

This project uses CMake as its build system, with support for CMake Presets to simplify configuration and building.

For detailed build instructions, including how to build the project, run tests, enable optional code quality tools (code coverage, sanitizers, static analysis, etc) and generate documentation, please see the [Building guide](BUILDING.md).

## Examples

When the C++ project is a library, this section is usually present and contains some code examples of how to use the library.

In the end of this section, it should mention something similar to the following:

"For more usage examples, please explore the [examples](./examples/) directory.".

## Integration

If the project is a library, this section can be included here to explain how the library can be integrated into the user project.

The content of this section available in this project is just an example, and considers that the library is named as "my_library".

This library creates a CMake target that can be linked in your project, and there are many ways to make this library available for that.

### Using CMake `FetchContent` module

CMake `FetchContent` module can be used to automatically download this library as a dependency when configuring your project. For that, you just need to place this code in your `CMakeLists.txt` file:

```cmake
include(FetchContent)
FetchContent_Declare(
    mylibrary
    GIT_REPOSITORY <repository_url> # Adjust to your needs.
    GIT_TAG <tag> # Tag or a commit hash if you prefer.
)
FetchContent_MakeAvailable(mylibrary)
# ...
target_link_libraries(your-target PRIVATE my_library::my_library)
```

### Copying the entire project

You can copy the entire project source tree into your project, and in your `CMakeLists.txt` file:

```cmake
add_subdirectory(my-library) # This is the repository/project name.
# ...
target_link_libraries(your-target PRIVATE my_library::my_library)
```

### Using as `git submodule`

You can also use this library as a `git submodule` in your project. For this case, the CMake code needed is the same as the one demonstrated if this entire project was copied into your project.

## Contributing to the project

If the project is open for contributions, it might make sense to have this section to explain briefly how to contribute to the project. Usually, it is common to have a `CONTRIBUTING.md` file in the project directory that explains it in more detail.

This project contains this [CONTRIBUTING](./CONTRIBUTING.md) file, just for demonstration purposes, that can be used as an example for another project. In that project, this section could have the following phrase:

"We welcome contributions to this project! There are many ways to contribute, from reporting bugs to suggesting features and submitting code. For more details on how to contribute to this project, please see the [Contributing guide](./CONTRIBUTING.md)."

## Future work

- Code quality tools:
    - Add cppcheck (code static analysis).
    - Add valgrind (memory checker).
    - Add tool to check CMake code format.

## License

Licensed under the [MIT license](./LICENSE).
