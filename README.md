# C++ project template

This project consists of a simple template that can be used for C++ development, using CMake as build system.

## Table of contents

- [Project structure](#project-structure)
- [Documentation](#documentation)
- [Requirements](#requirements)
    - [Using Docker](#using-docker)
- [Compilation](#compilation)
- [Running](#running)
- [Tests](#tests)
- [Supported compilers](#supported-compilers)
- [Code coverage](#code-coverage)
- [Doxygen documentation](#doxygen-documentation)
- [Code formatting](#code-formatting)
- [Code static analysis](#code-static-analysis)
- [Future work](#future-work)
- [License](#license)

## Project structure

This project is structured in the following directories:

- `cmake`: useful CMake files.
- `docker`: Dockerfile example and a guide.
- `docs`: project documentation.
- `doxygen`: configuration used to build doxygen documentation.
- `scripts`: useful scripts.
- `src`: source code of the project.
- `tests`: files related with tests.

## Documentation

This section could describe the documentation available in the `docs` directory, and eventually some links with information related to the project. In the case of this template, the `docs` directory has only a `README` file.

## Requirements

These tools need to be installed on the system:

- [CMake](https://cmake.org/): system to manage the build process.
- C++ compiler: for software compilation (examples: Microsoft Visual C++, GCC and Clang).
- [LCOV](https://github.com/linux-test-project/lcov): to obtain the code coverage.
- [Doxygen](https://doxygen.nl/): for generation of documentation from source code.
- [Clang-format](https://clang.llvm.org/docs/ClangFormat.html): for code formatting.
- [Clang-tidy](https://clang.llvm.org/extra/clang-tidy/): for code static analysis.

### Using Docker

There is a docker image available for this project that contains all the dependencies to compile and run this software. The instructions to use it can be found [here](./docker/README.md). For this approach, the only tool that needs to be installed on the system is:

- [Docker](https://docs.docker.com/get-docker/): platform for developing, shipping, and running applications.

## Compilation

The CMake options for configuration of this project are:

| CMake option | Description | Default value |
| --- | --- | --- |
| BUILD_TESTS | Build unit tests | OFF |
| BUILD_COVERAGE | Build with code coverage (for GCC only) | OFF |

The following commands can be utilized to configure the project (example for Debug configuration):

```sh
$ cd <project-directory>
$ mkdir build-debug
$ cd build-debug
$ cmake .. -DCMAKE_BUILD_TYPE=Debug
```

To compile the software, use the CMake build command (universal command for building, that abstracts a native build tool's command-line interface):

```sh
$ cmake --build . -j 4
```

It is also possible to compile the project calling the underlying build system directly (example for Unix Makefiles):

```sh
$ make -j 4
```

## Running

After compiling the project, an executable file is created and can be run using the following command (note that some configuration generators (e.g., Visual Studio) may add a configuration folder (e.g., Debug) in the path):

```sh
$ ./bin/<config>/ProjectTemplate
```

## Tests

To run the unit tests, use the commands below (note that it is necessary to configure CMake with `BUILD_TESTS` option to ON):

```sh
$ cd <project-directory>
$ mkdir build-debug
$ cd build-debug
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTS=ON
$ cmake --build . -j 4
$ ctest
```

## Supported compilers

This project was successfully built using the following compilers (it might also compile using other):

- GCC 9.4.0
- Microsoft Visual C++ 2022 / Build Tools 19.32.31332

## Code coverage

The project can be compiled for code coverage analysis, using the following commands (for GCC only):

```sh
$ cd <project-directory>
$ mkdir build-coverage
$ cd build-coverage
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUILD_COVERAGE=ON
$ cmake --build . -j 4
```

[LCOV](https://github.com/linux-test-project/lcov) is used to generate the report with the code coverage analysis. For that purpose, use the correspondent script available in the `scripts` directory as follows (note that this script already configures CMake and builds the project, so it is not needed to run the commands described previously):

```sh
$ cd <project-directory>
$ ./scripts/coverage-lcov-gen.sh
```

The code coverage analysis results are created and can be accessed in `build-coverage/coverage/index.html`.

## Doxygen documentation

The [doxygen](https://doxygen.nl/) tool is used to generate documentation from source code. The correspondent script generates the doxygen documentation, using the following commands:

```sh
$ cd <project-directory>
$ ./scripts/doxygen-doc-gen.sh
```

The documentation is created and can be accessed in `build-doxygen/html/index.html`. Also, a report file is created in the `build-doxygen` directory.

## Code formatting

The format of the code can be checked with [clang-format](https://clang.llvm.org/docs/ClangFormat.html), using the correspondent script:

```sh
$ cd <project-directory>
$ ./scripts/clang-format-check.sh
```

A report file is created in the `build-clang-format` directory.

## Code static analysis

For code static analysis, it is used the [clang-tidy](https://clang.llvm.org/extra/clang-tidy/) tool. The correspondent script can be utilized to analyze the code:

```sh
$ cd <project-directory>
$ ./scripts/clang-tidy-check.sh
```

A report file is created in the `build-clang-tidy` directory.

## Future work

List of tasks to be done in the future:

- Create CMake targets for code coverage, documentation generation, code formatting and code static analysis.
- Add CI pipelines.
- Add `cppcheck` tool for code static analysis.
- Add sanitizers (address, memory and thread).
- Add memory checker `valgrind`.

## License

Licensed under the [MIT license](./LICENSE).
