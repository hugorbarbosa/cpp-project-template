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
- [Coding style and format](#coding-style-and-format)
- [Code static analysis](#code-static-analysis)
- [Source code documentation](#source-code-documentation)
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

Using this project as example, the following is what this section could have:

"Documentation of this project is available in [`doc`](./doc/), and includes the following:

- Description of some examples of what can be inserted as documentation of a project (architecture diagrams, user guides, etc).
- Details about some code quality tools used by this project."

## Requirements

The following tools are used by this project:

- CMake: system to manage the build process.
- C++ compiler: for software compilation (examples: Microsoft Visual C++, GCC and Clang).
- LCOV: to obtain the code coverage report.
- Doxygen: for generation of documentation from source code.
- Clang-format: for code formatting.
- Clang-tidy: for code static analysis.

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about some of those tools.

### Using Docker

There is a Docker image available in this project that contains all the dependencies to compile and run this software, as well as the required tools. This allows to quickly use this project without installing any tool in the local machine.

The instructions to use the docker image can be found [here](./docker/README.md).

## Supported compilers

This project can be successfully built using the following compilers (it might also succeed using another one):

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
$ cmake .. -DCMAKE_BUILD_TYPE=Debug -DCXXPROJT_ENABLE_COVERAGE=ON
$ cmake --build . --target coverage
```

This target compiles and generates a report with the code coverage analysis, using the LCOV tool. This report is placed inside of the build directory (`build-coverage` in this example), being available in `coverage/index.html`.

Additionally, this target also verifies the code coverage percentage and succeeds or fails if the coverage is sufficient or not, respectively. The accepted coverage percentage value can be configured by the user (see [CMakeLists](./CMakeLists.txt) of the project for more details).

## Coding style and format

This projects follows my [C++ coding style guide](https://github.com/hugorbarbosa/cpp-coding-style-guide). To ensure consistency, the format of the code can be checked using the commands below:

```sh
$ cd <project-directory>
$ mkdir build-format
$ cd build-format
$ cmake .. -DCXXPROJT_ENABLE_FORMAT=ON
$ cmake --build . --target format
```

This target uses clang-format to verify the format of the code, and creates a report file in the `build-format` directory (used build directory in this example), named as `format-report.log`.

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

This target generates documentation from the source files using doxygen, in the `build-doxygen` directory (used build directory in this example), which can be accessed from `html/index.html`. Furthermore, a report file named as `doxygen-report.log` is also created in this build directory.

This target only succeeds if the source files are correctly documented. The doxygen [configuration](./doxygen/Doxyfile.in) file in this project is prepared to be automatically configured through CMake by the user, namely the source files from which documentation should be generated, as well as other parameters related to the project (see [CMakeLists](./CMakeLists.txt) of the project for more details).

Please consult the [code quality tools](./doc/code-quality-tools.md) documentation to know more details about doxygen.

## Contributing to the project

If the project is open for contributions, it might make sense to have this section to explain briefly how to contribute to the project. Usually, it is common to have a `CONTRIBUTING.md` file in the project directory that explains it in more detail.

This project contains this [CONTRIBUTING](./CONTRIBUTING.md) file, just for demonstration purposes, that can be used as an example for another project. In that project, this section could have the following phrase:

"We welcome contributions to this project! There are many ways to contribute, from reporting bugs to suggesting features and submitting code. For more details on how to contribute to this project, please see the [contributing guide](./CONTRIBUTING.md)."

## Future work

List of tasks to be done in the future:

- Improvements:
    - Use `target_compile_options` instead of `add_compile_options`.
- Code quality tools:
    - Add address, memory, thread and undefined behavior sanitizers.
    - Add cppcheck tool for code static analysis.
    - Add valgrind (memory checker).
- CI:
    - Add CI pipelines to build the project, to run the tests, and to use all the code quality tools and sanitizers.

## License

Licensed under the [MIT license](./LICENSE).
