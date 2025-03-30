# C++ project template

This project consists of a C++ project template that can be used as a starting point of a new C++ project, using CMake as build system.

## Table of contents

- [Project structure](#project-structure)
- [Documentation](#documentation)
- [Requirements](#requirements)
    - [Using Docker](#using-docker)
- [Supported compilers](#supported-compilers)
- [Compilation](#compilation)
- [Running](#running)
- [Tests](#tests)
- [Code coverage](#code-coverage)
- [Coding style](#coding-style)
- [Code static analysis](#code-static-analysis)
- [Doxygen documentation](#doxygen-documentation)
- [Contributing to the project](#contributing-to-the-project)
- [Future work](#future-work)
- [License](#license)

## Project structure

This project template is structured in the following directories:

- `cmake`: useful CMake files.
- `doc`: project documentation.
- `docker`: Dockerfile example and a guide.
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

## Requirements

The following tools are used by this project:

- CMake: system to manage the build process.
- C++ compiler: for software compilation (examples: Microsoft Visual C++, GCC and Clang).
- LCOV: to obtain the code coverage.
- Doxygen: for generation of documentation from source code.
- Clang-format: for code formatting.
- Clang-tidy: for code static analysis.

### Using Docker

There is a Docker image available for this project that contains all the dependencies to compile and run this software, as well as the tools used by this project. This allows to quickly use this project without being necessary the installation of any tool in the local system.

The instructions to use the docker image can be found [here](./docker/README.md).

## Supported compilers

This project can be successfully compiled using the following compilers (it might also succeed using another compiler):

- Clang 18.1.3
- GCC 13.3.0
- Microsoft Visual C++ 2022 / Build Tools 19.32.31332

## Compilation

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
$ ./bin/<config>/cpp-project-template
```

## Tests

To run the unit tests, use the commands below:

```sh
$ cd <project-directory>
$ mkdir build-debug
$ cd build-debug
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_TESTS=ON
$ cmake --build . -j 4
$ ctest
```

## Code coverage

The project can be compiled for code coverage analysis (for GCC only), using the following commands:

```sh
$ cd <project-directory>
$ mkdir build-coverage
$ cd build-coverage
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_BUILD_COVERAGE=ON
$ cmake --build . -j 4
```

LCOV is used to generate the report with the code coverage analysis. For that purpose, use the correspondent script available in the `scripts` directory as follows (note that this script already configures CMake and builds the project, so it is not necessary to run the commands described previously):

```sh
$ cd <project-directory>
$ ./scripts/coverage-lcov-gen.sh
```

The code coverage analysis results are created and can be accessed in `build-coverage/coverage/index.html`.

## Coding style

This projects follows my [C++ coding style guide](https://github.com/hugorbarbosa/cpp-coding-style-guide). To ensure consistency, the format of the code can be checked with clang-format, using the commands below:

```sh
$ cd <project-directory>
$ mkdir build-clang-format
$ cd build-clang-format
$ cmake .. -DCXXPROJT_ENABLE_FORMAT_CHECKER=ON
$ cmake --build . --target format
```

A report file is created in the `build-clang-format` directory (used build directory in this example).

## Code static analysis

For code static analysis, it is used the clang-tidy tool. The correspondent script can be utilized to analyze the code:

```sh
$ cd <project-directory>
$ ./scripts/clang-tidy-check.sh
```

A report file is created in the `build-clang-tidy` directory.

## Doxygen documentation

The Doxygen tool is used to generate documentation from source code. The correspondent script generates the doxygen documentation, using the following commands:

```sh
$ cd <project-directory>
$ ./scripts/doxygen-doc-gen.sh
```

The documentation is created and can be accessed in `build-doxygen/html/index.html`. Furthermore, a report file is created in the `build-doxygen` directory.

## Contributing to the project

If the project is open for contributions, it might make sense to have this section to explain briefly how to contribute to the project. Usually, it is common to have a `CONTRIBUTING.md` file in the project directory that explains it in more detail.

This project contains this [CONTRIBUTING](./CONTRIBUTING.md) file, just for demonstration purposes, that can be used as an example for another project. In that project, this section could have the following phrase:

"We welcome contributions to this project! There are many ways to contribute, from reporting bugs to suggesting features and submitting code. For more details, please see the [contributing guide](./CONTRIBUTING.md) for details on how to contribute to this project."

## Future work

List of tasks to be done in the future:

- Improvements:
    - Create CMake targets for code coverage, documentation generation, and code static analysis.
    - Avoid manual settings adjustment of the Doxyfile for a given project (name, version, etc), using CMake to automatically configure those settings.
- CI:
    - Add CI pipelines to build the project, run the tests, check the code coverage, check the code format, and run static analysis and sanitizers.
- Quality:
    - Add cppcheck tool for code static analysis.
    - Add address, memory and thread sanitizers.
    - Add valgrind (memory checker).

## License

Licensed under the [MIT license](./LICENSE).
