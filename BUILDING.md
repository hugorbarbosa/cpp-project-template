# Building

This guide provides detailed instructions to build the project, namely how to compile it, run tests, enable optional code quality tools and generate documentation.

## Table of contents

- [Requirements](#requirements)
    - [Using Docker](#using-docker)
- [Basic build](#basic-build)
- [Running the executable](#running-the-executable)
- [Tests](#tests)
- [Code coverage](#code-coverage)
- [Coding style and format](#coding-style-and-format)
- [Code static analysis](#code-static-analysis)
- [Sanitizers](#sanitizers)
    - [Address sanitizer](#address-sanitizer)
    - [Leak sanitizer](#leak-sanitizer)
    - [Memory sanitizer](#memory-sanitizer)
    - [Thread sanitizer](#thread-sanitizer)
    - [Undefined behavior sanitizer](#undefined-behavior-sanitizer)
- [Source code documentation](#source-code-documentation)

## Requirements

These tools are required to configure and build the project:

- CMake >= 3.21.
- C++ compiler: this project can be successfully built using the following compilers (it might also succeed using another one):
    - Clang 18.1.3.
    - GCC 13.3.0.
    - Microsoft Visual C++ 2022 / Build Tools 19.43.34808.0.
- Git.

The following are the code quality tools used by the project (only required for developers contributing to the project or working on internal tooling):

- LCOV: code coverage reporting.
- Clang-format: code formatting.
- Clang-tidy: code static analysis.
- Doxygen: generation of documentation.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about some of those tools.

### Using Docker

There is a Docker image available in this project that contains all the dependencies to build the project, as well as the development tools. This allows to quickly use the project without installing any tool in the local machine.

The instructions to use the docker image can be found [here](./docker/README.md).

## Basic build

For Debug build, using the standard CMake configure and build commands:

```sh
$ cd <project-directory>
$ cmake -S . -B ./build-debug -DCMAKE_BUILD_TYPE=Debug
$ cmake --build ./build-debug -j 4
```

This project supports CMake Presets ([CMakePresets.json](./CMakePresets.json)), which specifies some common configuration options to facilitate the building of the project and the sharing of these settings with the developers/users.

The previous standard CMake commands can be replaced by the equivalent CMake Preset commands to configure and build the project, using the GCC compiler in this case but there are more compiler options available in the CMake presets of this project (build directory is automatically created using presets, being its name specified in the `CMakePresets.json` file):

```sh
$ cd <project-directory>
$ cmake --preset debug-gcc
$ cmake --build --preset debug-gcc
```

For Release build, using the standard CMake commands:

```sh
$ cd <project-directory>
$ cmake -S . -B ./build-release -DCMAKE_BUILD_TYPE=Release
$ cmake --build ./build-release -j 4
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset release-gcc
$ cmake --build --preset release-gcc
```

To list all the CMake configuration presets available for this project:

```sh
$ cd <project-directory>
$ cmake --list-presets=configure
$ cmake --list-presets=build
$ cmake --list-presets=test
```

## Running the executable

After compiling the project, an executable file is created and can be run using the following command (note that some configuration generators (e.g., Visual Studio) may add a configuration folder (e.g., Debug) in the path):

```sh
$ cd <build-directory>
$ ./bin/<config>/cpp-project-template
```

## Tests

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-debug
$ cd build-debug
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON
$ cmake --build . -j 4
$ ctest
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset debug-gcc
$ cmake --build --preset debug-gcc
$ ctest --preset debug-gcc
```

## Code coverage

Using the standard CMake commands (with GCC compiler only):

```sh
$ cd <project-directory>
$ mkdir build-coverage
$ cd build-coverage
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_ENABLE_COVERAGE=ON
$ cmake --build . --target coverage
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset coverage
$ cmake --build --preset coverage
```

This target compiles and generates a report with the code coverage analysis, using the LCOV tool. This report is placed inside of the build directory (`build-coverage` in this example), being available in `coverage/index.html`.

Additionally, this target also verifies the code coverage percentage and succeeds or fails if the coverage is sufficient or not, respectively. The accepted coverage percentage value is configured through CMake.

## Coding style and format

This projects follows my [C++ coding style guide](https://github.com/hugorbarbosa/cpp-coding-style-guide), and to ensure consistency, clang-format is used to check the format of the code.

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-clang-format
$ cd build-clang-format
$ cmake .. -DCXXPROJT_ENABLE_CLANG_FORMAT=ON
$ cmake --build . --target clang_format
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset clang-format
$ cmake --build --preset clang-format
```

This target uses clang-format to verify the format of the code, and creates a report file in the `build-clang-format` directory (used build directory in this example), named as `clang-format-report.log`.

The build succeeds only if the source files are formatted accordingly to the [configuration](.clang-format) file. The project source files to be verified are configured through CMake.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about clang-format.

## Code static analysis

The project is prepared to execute code static analysis with clang-tidy.

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-clang-tidy
$ cd build-clang-tidy
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_ENABLE_CLANG_TIDY=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
$ cmake --build . --target clang_tidy
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset clang-tidy
$ cmake --build --preset clang-tidy
```

This target runs clang-tidy and generates a report with the results of the code static analysis, named as `clang-tidy-report.log` and placed inside of the build directory (`build-clang-tidy` in this example).

The build succeeds only if no issues are found during the code static analysis, which utilizes the list of checks provided in the respective [configuration](.clang-tidy) file. The project source files to be analyzed are configured through CMake.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about clang-tidy.

## Sanitizers

Sanitizers are tools integrated into modern compilers that are able to catch many types of issues, such as memory errors, undefined behavior or thread race conditions.

This project is prepared to easily enable the sanitizers described below. If a sanitizer detects an issue, a diagnostic report is printed containing detailed information.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about each sanitizer.

### Address sanitizer

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-sanitizer-address
$ cd build-sanitizer-address
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON -DCXXPROJT_ENABLE_ASAN=ON
$ cmake --build . -j 4
$ ctest
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset sanitizer-address
$ cmake --build --preset sanitizer-address
$ ctest --preset sanitizer-address
```

### Leak sanitizer

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-sanitizer-leak
$ cd build-sanitizer-leak
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON -DCXXPROJT_ENABLE_LSAN=ON
$ cmake --build . -j 4
$ ctest
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset sanitizer-leak
$ cmake --build --preset sanitizer-leak
$ ctest --preset sanitizer-leak
```

### Memory sanitizer

Using the standard CMake commands (with clang compiler only):

```sh
$ cd <project-directory>
$ mkdir build-sanitizer-memory
$ cd build-sanitizer-memory
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON -DCXXPROJT_ENABLE_MSAN=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
$ cmake --build . -j 4
$ ctest
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset sanitizer-memory
$ cmake --build --preset sanitizer-memory
$ ctest --preset sanitizer-memory
```

### Thread sanitizer

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-sanitizer-thread
$ cd build-sanitizer-thread
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON -DCXXPROJT_ENABLE_TSAN=ON
$ cmake --build . -j 4
$ ctest
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset sanitizer-thread
$ cmake --build --preset sanitizer-thread
$ ctest --preset sanitizer-thread
```

### Undefined behavior sanitizer

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-sanitizer-undefined
$ cd build-sanitizer-undefined
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON -DCXXPROJT_ENABLE_UBSAN=ON
$ cmake --build . -j 4
$ ctest
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset sanitizer-undefined
$ cmake --build --preset sanitizer-undefined
$ ctest --preset sanitizer-undefined
```

## Source code documentation

Doxygen is used to generate documentation from source code in this project.

Using the standard CMake commands:

```sh
$ cd <project-directory>
$ mkdir build-doxygen
$ cd build-doxygen
$ cmake .. -DCXXPROJT_ENABLE_DOXYGEN=ON
$ cmake --build . --target doxygen
```

CMake Preset equivalent:

```sh
$ cd <project-directory>
$ cmake --preset doxygen
$ cmake --build --preset doxygen
```

This target generates documentation from the source files using doxygen, in the `build-doxygen` directory (used build directory in this example), which can be accessed from `html/index.html`. Furthermore, a report file named as `doxygen-report.log` is also created in this build directory.

This target only succeeds if the source files are correctly documented. The doxygen [configuration](./doxygen/Doxyfile.in) file in this project is prepared to be automatically configured through CMake, namely the source files from which documentation should be generated, as well as other parameters related to the project.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about doxygen.
