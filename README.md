# C++ project template

This project provides a comprehensive C++ project template, designed to help you quickly get started with a C++ project.

It offers a clear project structure, essential configurations, and integrates code quality tools to ensure clean, maintainable code right from the start.

## Table of contents

- [Features](#features)
- [Getting started](#getting-started)
- [Project structure](#project-structure)
- [Documentation](#documentation)
- [Requirements](#requirements)
    - [Using Docker](#using-docker)
- [Examples](#examples)
- [Integration](#integration)
- [Supported compilers](#supported-compilers)
- [Building](#building)
- [Running the executable](#running-the-executable)
- [Tests](#tests)
- [Code coverage](#code-coverage)
- [Coding style and format](#coding-style-and-format)
- [Code static analysis](#code-static-analysis)
- [Source code documentation](#source-code-documentation)
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
    - Documentation.
- Code quality tools configured to be easily executed and ready for integration into CI pipelines.
- Automatic dependency fetching, using CMake, for easy integration of third-party libraries.
- Templates for README and Contributing guide.
- Example of a Dockerfile.

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

## Requirements

The following tools are used by this project:

- CMake: system to manage the build process.
- C++ compiler: for software compilation (examples: Microsoft Visual C++, GCC and Clang).
- LCOV: to obtain the code coverage report.
- Clang-format: for code formatting.
- Clang-tidy: for code static analysis.
- Doxygen: for generation of documentation from source code.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about some of those tools.

### Using Docker

There is a Docker image available in this project that contains all the dependencies to compile and run this software, as well as the required tools. This allows to quickly use this project without installing any tool in the local machine.

The instructions to use the docker image can be found [here](./docker/README.md).

## Examples

When the C++ project is a library, this section is usually present and contains some code examples of how to use the library.

In the end of this section, it should mention something similar to the following:

"For more usage examples, please explore the [examples](./examples/) directory.".

## Integration

If the project is a library, this section can be included here to refer how the library can be integrated into the user project.

The content of this section that is available in this project is an example, which considers that the library is named as "my_library".

This library creates a CMake target that can be linked in your project, and there are many ways to make this library available to be used in your project.

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

## Supported compilers

This project can be successfully built using the following compilers (it might also succeed using another one):

- Clang 18.1.3
- GCC 13.3.0
- Microsoft Visual C++ 2022 / Build Tools 19.32.31332

## Building

The following commands can be utilized to configure the project (example for Debug build type):

```sh
$ cd <project-directory>
$ mkdir build-debug
$ cd build-debug
$ cmake .. -DCMAKE_BUILD_TYPE=Debug
```

Alternatively to creating the build directory manually, the following CMake command can be used to create it automatically, but the result will be exactly the same:

```sh
$ cd <project-directory>
$ cmake -S . -B ./build-debug -DCMAKE_BUILD_TYPE=Debug
```

To compile the software, use the CMake build command (universal command for building, that abstracts a native build tool's command-line interface):

```sh
$ cd build-debug
$ cmake --build . -j 4
```

Although it is recommended to use the CMake build command, it is also possible to compile the project calling the underlying build system directly (example for Unix Makefiles):

```sh
$ make -j 4
```

This project provides this [CMakePresets.json](./CMakePresets.json) file, which specifies some common configuration options to facilitate the building of the project and the sharing of these settings with the developers/users, presets that can also support CI pipelines.

To list all the CMake configuration presets available for this project, use the following commands (must be executed in the project directory, where the `CMakePresets.json` is located):

```sh
$ cd <project-directory>
$ cmake --list-presets
```

Besides the configure presets, there are build and test presets already available, which can be listed specifying the type as follows:

```sh
$ cmake --list-presets=configure
$ cmake --list-presets=build
$ cmake --list-presets=test
```

The usage of the CMake presets allows to avoid the definition of the necessary variables for the desired build (in the example used, `CMAKE_BUILD_TYPE=Debug` for Debug build), therefore the previous configure and build commands can be replaced by the following commands to configure and build the project, using the GCC compiler in this case but there are more compiler options available in the JSON file (build directory is automatically created using presets):

```sh
$ cd <project-directory>
$ cmake --preset debug-gcc
$ cmake --build --preset debug-gcc
```

## Running the executable

After compiling the project, an executable file is created and can be run using the following command (note that some configuration generators (e.g., Visual Studio) may add a configuration folder (e.g., Debug) in the path):

```sh
$ cd <build-directory>
$ ./bin/<config>/cpp-project-template
```

## Tests

To compile and run the tests, use the commands below:

```sh
$ cd <project-directory>
$ mkdir build-debug
$ cd build-debug
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON
$ cmake --build . -j 4
$ ctest
```

Alternatively, CMake presets can be applied as follows to run the tests, configuring automatically the needed variables:

```sh
$ cd <project-directory>
$ cmake --preset debug-gcc
$ cmake --build --preset debug-gcc
$ ctest --preset test-debug-gcc
```

## Code coverage

The project can be compiled for code coverage analysis (for GCC only), using the following commands:

```sh
$ cd <project-directory>
$ mkdir build-coverage
$ cd build-coverage
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_ENABLE_COVERAGE=ON
$ cmake --build . --target coverage
```

CMake presets may be utilized instead of the previous commands to run code coverage analysis:

```sh
$ cd <project-directory>
$ cmake --preset coverage
$ cmake --build --preset coverage
```

This target compiles and generates a report with the code coverage analysis, using the LCOV tool. This report is placed inside of the build directory (`build-coverage` in this example), being available in `coverage/index.html`.

Additionally, this target also verifies the code coverage percentage and succeeds or fails if the coverage is sufficient or not, respectively. The accepted coverage percentage value can be configured by the user (see [CMakeLists](./CMakeLists.txt) of the project for more details).

## Coding style and format

This projects follows my [C++ coding style guide](https://github.com/hugorbarbosa/cpp-coding-style-guide). To ensure consistency, the format of the code can be checked using the commands below:

```sh
$ cd <project-directory>
$ mkdir build-clang-format
$ cd build-clang-format
$ cmake .. -DCXXPROJT_ENABLE_CLANG_FORMAT=ON
$ cmake --build . --target clang_format
```

Alternatively, use CMake presets as follows to check the code format:

```sh
$ cd <project-directory>
$ cmake --preset clang-format
$ cmake --build --preset clang-format
```

This target uses clang-format to verify the format of the code, and creates a report file in the `build-clang-format` directory (used build directory in this example), named as `clang-format-report.log`.

The build succeeds only if the source files are formatted accordingly to the [configuration](.clang-format) file. The project source files to be verified can be configured by the user (see [CMakeLists](./CMakeLists.txt) of the project for more details).

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about clang-format.

## Code static analysis

Clang-tidy is a tool that can be used to perform code static analysis. The project is prepared to execute this type of analysis using this tool, applying the following commands:

```sh
$ cd <project-directory>
$ mkdir build-clang-tidy
$ cd build-clang-tidy
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_ENABLE_CLANG_TIDY=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
$ cmake --build . --target clang_tidy
```

Alternatively to using the previous commands, CMake presets may be applied to facilitate the build to perform static analysis using clang-tidy:

```sh
$ cd <project-directory>
$ cmake --preset clang-tidy
$ cmake --build --preset clang-tidy
```

This target runs clang-tidy and generates a report with the results of the code static analysis, named as `clang-tidy-report.log` and placed inside of the build directory (`build-clang-tidy` in this example).

The build succeeds only if no issues are found during the code static analysis, which utilizes the list of checks provided in the respective [configuration](.clang-tidy) file. The project source files to be analyzed can be configured by the user (see [CMakeLists](./CMakeLists.txt) of the project for more details).

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about clang-tidy.

## Source code documentation

Doxygen is used to generate documentation from source code, and the commands below can be used for that purpose:

```sh
$ cd <project-directory>
$ mkdir build-doxygen
$ cd build-doxygen
$ cmake .. -DCXXPROJT_ENABLE_DOXYGEN=ON
$ cmake --build . --target doxygen
```

The respective CMake presets can be used instead of the previous commands to run doxygen:

```sh
$ cd <project-directory>
$ cmake --preset doxygen
$ cmake --build --preset doxygen
```

This target generates documentation from the source files using doxygen, in the `build-doxygen` directory (used build directory in this example), which can be accessed from `html/index.html`. Furthermore, a report file named as `doxygen-report.log` is also created in this build directory.

This target only succeeds if the source files are correctly documented. The doxygen [configuration](./doxygen/Doxyfile.in) file in this project is prepared to be automatically configured through CMake by the user, namely the source files from which documentation should be generated, as well as other parameters related to the project (see [CMakeLists](./CMakeLists.txt) of the project for more details).

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about doxygen.

## Contributing to the project

If the project is open for contributions, it might make sense to have this section to explain briefly how to contribute to the project. Usually, it is common to have a `CONTRIBUTING.md` file in the project directory that explains it in more detail.

This project contains this [CONTRIBUTING](./CONTRIBUTING.md) file, just for demonstration purposes, that can be used as an example for another project. In that project, this section could have the following phrase:

"We welcome contributions to this project! There are many ways to contribute, from reporting bugs to suggesting features and submitting code. For more details on how to contribute to this project, please see the [contributing guide](./CONTRIBUTING.md)."

## Future work

List of tasks to be done in the future:

- Code quality tools:
    - Add address, leak, memory, thread and undefined behavior sanitizers.
    - Add cppcheck tool for code static analysis.
    - Add valgrind (memory checker).
    - Add tool to check CMake code format.
- CI:
    - Add CI pipelines, with GitHub Actions, to build the project, to run the tests, and to use all the code quality tools and sanitizers.

## License

Licensed under the [MIT license](./LICENSE).
