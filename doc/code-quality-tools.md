# Code quality tools

This project uses many code quality tools commonly utilized in a C++ project. This document describes in more detail some of those tools.

## Table of contents

- [Clang-format](#clang-format)
- [Clang-tidy](#clang-tidy)
- [Doxygen](#doxygen)
- [Sanitizers](#sanitizers)
    - [Address sanitizer](#address-sanitizer)
    - [Leak sanitizer](#leak-sanitizer)
    - [Memory sanitizer](#memory-sanitizer)
    - [Thread sanitizer](#thread-sanitizer)
    - [Undefined behavior sanitizer](#undefined-behavior-sanitizer)
- [References](#references)

## Clang-format

Clang-format is a tool that can be used to format C++, C, C#, Java, JavaScript, JSON, Objective-C and Protobuf code. This tool can be utilized in a variety of ways, including as a standalone tool or integrated in a IDE/editor.

Clang-format supports many options which can be found using the `--help` option:

```sh
$ clang-format --help
```

This tool allows you to directly apply a predefined code style, based on styles such as Google, Microsoft, among others. This base style can be adjusted to your needs or, if necessary, you can completely customize a style with your desired style options. All style options supported by clang-format can be found in [clang-format style options][ref-tool-clang-format-style-options].

This project uses this [clang-format configuration file](../.clang-format), which includes the desired style options for this project, but can be used as example and be adjusted to your needs.

As previously mentioned, clang-format can be integrated in a IDE/editor, like Visual Studio Code. It is only necessary to install the [C/C++ extension][ref-vscode-cpp-extension], which allows configuring and using clang-format from the Visual Studio Code. Additionally, you can configure to automatically format the code when saving a file (see the [settings](../.vscode/settings.json) file as example).

Please refer to the [clang-format page][ref-tool-clang-format] for more details regarding this tool.

## Clang-tidy

Clang-tidy is a clang-based C++ "linter" tool, that provides an extensible framework for diagnosing and fixing typical programming errors, like interface misuse or bugs, that can be deduced via static analysis. It can be utilized as a standalone tool or integrated in a IDE/editor.

Clang-tidy supports many options which can be found using the `--help` option:

```sh
$ clang-tidy --help
```

This tool allows you to specify various check options based on groups through a name prefix, such as `cppcoreguidelines-` that performs checks related to C++ Core Guidelines. All check options supported by clang-tidy can be found in [clang-tidy checks][ref-tool-clang-tidy-checks].

This project uses this [clang-tidy configuration file](../.clang-tidy), which includes the desired check options for this project, but can be used as example and be adjusted to your needs.

As previously mentioned, clang-tidy can be integrated in a IDE/editor, like Visual Studio Code. The [C/C++ extension][ref-vscode-cpp-extension] needs to be installed for configuring and using clang-tidy from the Visual Studio Code. Additionally, you can configure to automatically analyze the code when saving a file (see the [settings](../.vscode/settings.json) file available as example).

Please refer to the [clang-tidy page][ref-tool-clang-tidy] for more details regarding this tool.

## Doxygen

Doxygen is a documentation generator tool that automates the creation of documentation from source code comments, supporting C++, C, C#, Python, PHP, Java, Objective-C, Fortran, VHDL, Splice, IDL, and Lex code. The documentation can be generated in various output formats, such as HTML and PDF. Moreover, this tool is able to generate graphical representations of class hierarchies and collaboration diagrams, providing a visual overview of the relationships between classes and functions.

Doxygen supports many options which can be found using the `--help` option:

```sh
$ doxygen --help
```

This tool utilizes a configuration file (Doxyfile) that permits users to customize the documentation generation process, like the input files and the output format. This project uses this [doxygen configuration file](../doxygen/Doxyfile), which includes the desired options for this project, but can be used as example and be adjusted to your needs.

The format of the source code comments needs to follow some rules, in order to generate documentation from those comments by this tool.

Please refer to the [Doxygen page][ref-tool-doxygen] for more details regarding this tool.

## Sanitizers

Sanitizers are tools integrated into modern compilers, such as GCC and Clang, that help detect bugs in programs at runtime. These tools can be enabled for code compilation and are able to catch common but hard-to-find issues such as memory errors, undefined behavior, or thread race conditions. Therefore, sanitizers allow early bug detection and improve code reliability, stability, and security.

When the code is compiled with a sanitizer enabled:

- The compiler inserts special instrumented code.
- At runtime, this instrumentation monitors the behavior of the program.
- If an issue is detected, it halts the program execution, prints a diagnostic report with detailed information (type of issue, file, line number, etc), and exits with a non-zero exit code.

There are some types of sanitizers that can be used in a C++ project, some of them are described in the next sections.

### Address sanitizer

AddressSanitizer (ASan) is a fast memory error detector, that instruments memory access instructions to detect issues such as:

- Out-of-bounds accesses to heap, stack and globals.
- Use-after-free bugs.
- Double-free and invalid free issues.

To enable AddressSanitizer, compile and link your program with `-fsanitize=address` option. To get a reasonable performance add `-O1` or higher, and to get nicer stack traces in error messages add `-fno-omit-frame-pointer`. Besides that, you should also use `-g` to produce more meaningful output. Note that the runtime behavior can be influenced by the `ASAN_OPTIONS` environment variable.

For example, the following code contains an *use after free* error that should be detected by this sanitizer:

```c++
// asan_example.cpp
int main(int argc, char* argv[])
{
    int *array = new int[42];
    delete [] array;
    return array[argc]; // Use after free.
}
```

Using the Clang compiler, the commands below can be utilized to compile and link with this sanitizer:

```sh
$ clang++ -fsanitize=address -O1 -g -fno-omit-frame-pointer asan_example.cpp
$ ./a.out
```

Please refer to the [AddressSanitizer][ref-tool-sanitizer-address] and [GCC program instrumentation options][ref-gcc-instrumentation-options] pages for more details regarding this tool.

**Notes:**

- AddressSanitizer cannot be combined with ThreadSanitizer.
- Typical slowdown introduced by AddressSanitizer is 2x.
- Supported by Clang, GCC and MSVC compilers.

### Leak sanitizer

LeakSanitizer (LSan) is a runtime memory leak detector, that can be used "standalone" or combined with AddressSanitizer.

To enable LeakSanitizer, compile and link your program with `-fsanitize=leak` option. Additionally, `-g` should also be used to produce more meaningful output. Note that the runtime behavior can be influenced by the `LSAN_OPTIONS` environment variable.

For example, the following code contains an *use after free* error that should be detected by this sanitizer:

```c
// lsan_example.c
#include <stdlib.h>
void *p;
int main()
{
    p = malloc(7);
    p = 0; // Memory leak.
    return 0;
}
```

Using the Clang compiler, the commands below can be utilized to compile and link with this sanitizer:

```sh
$ clang -fsanitize=leak -g -fno-omit-frame-pointer lsan_example.c
$ ./a.out
# Or combined with AddressSanitizer.
$ clang -fsanitize=address -g -fno-omit-frame-pointer lsan_example.c ; ASAN_OPTIONS=detect_leaks=1 ./a.out
```

Please refer to the [LeakSanitizer][ref-tool-sanitizer-leak] and [GCC program instrumentation options][ref-gcc-instrumentation-options] pages for more details regarding this tool.

**Notes:**

- LeakSanitizer cannot be combined with ThreadSanitizer.
- Almost no performance overhead is added by the LeakSanitizer until the very end of the process, at which point there is an extra leak detection phase.
- Supported by Clang and GCC compilers.

### Memory sanitizer

MemorySanitizer (MSan) is a detector of uninitialized memory use, that instruments the code to detect issues such as:

- Uninitialized value was used in a conditional branch.
- Uninitialized pointer was used for memory accesses.
- Uninitialized value was passed or returned from a function call, which is considered an undefined behavior.

To enable MemorySanitizer, compile and link your program with `-fsanitize=memory` option. To get a reasonable performance add `-O1` or higher, and to get nicer stack traces in error messages add `-fno-omit-frame-pointer`. Besides that, you should also use `-g` to produce more meaningful output. Note that the runtime behavior can be influenced by the `MSAN_OPTIONS` environment variable.

For example, the following code contains an *use of uninitialized value* error that should be detected by this sanitizer:

```c++
// msan_example.cpp
#include <stdio.h>
int main(int argc, char* argv[])
{
    int* a = new int[10];
    a[5] = 0;
    if (a[argc]) {
        printf("xx\n");
    }
    return 0;
}
```

Using the Clang compiler, the commands below can be utilized to compile and link with this sanitizer:

```sh
$ clang++ -fsanitize=memory -O2 -g -fno-omit-frame-pointer msan_example.cpp
$ ./a.out
```

Please refer to the [MemorySanitizer][ref-tool-sanitizer-memory] page for more details regarding this tool.

**Notes:**

- Typical slowdown introduced by MemorySanitizer is 3x.
- Supported by Clang compiler.
- MemorySanitizer requires that all program code is instrumented. This also includes any libraries that the program depends on, even libc. Failing to achieve this may result in false reports.

### Thread sanitizer

ThreadSanitizer (TSan) is a data race detector, that instruments memory access instructions to detect data race bugs.

To enable ThreadSanitizer, compile and link your program with `-fsanitize=thread` option. To get a reasonable performance add `-O1` or higher, and use `-g` to produce more meaningful output. Note that the runtime behavior can be influenced by the `TSAN_OPTIONS` environment variable.

For example, the following code contains a data race that should be detected by this sanitizer:

```c++
// tsan_example.c
#include <pthread.h>

int global;

void* thread1(void *x)
{
    global = 42;
    return x;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, thread1, NULL);
    global = 43;
    pthread_join(t, NULL);
    return global;
}
```

Using the Clang compiler, the commands below can be utilized to compile and link with this sanitizer:

```sh
$ clang -fsanitize=thread -O1 -g tsan_example.c
$ ./a.out
```

Please refer to the [ThreadSanitizer][ref-tool-sanitizer-thread] and [GCC program instrumentation options][ref-gcc-instrumentation-options] pages for more details regarding this tool.

**Notes:**

- ThreadSanitizer cannot be combined with AddressSanitizer and LeakSanitizer.
- Typical slowdown introduced by ThreadSanitizer is about 5x-15x.
- Typical memory overhead introduced by ThreadSanitizer is about 5x-10x.
- Supported by Clang and GCC compilers.

### Undefined behavior sanitizer

UndefinedBehaviorSanitizer (UBSan) is a fast undefined behavior detector, that instruments the code to detect issues during program execution such as:

- Array subscript out of bounds, where the bounds can be statically determined.
- Bitwise shifts that are out of bounds for their data type.
- Dereferencing misaligned or null pointers.
- Signed integer overflow.
- Conversion to, from, or between floating-point types which would overflow the destination.

To enable UndefinedBehaviorSanitizer, compile and link your program with `-fsanitize=undefined` option. In addition, this sanitizer can be configured with a specific check or group of checks, allowing to enable or disable them, using `-fsanitize=...` and `-fno-sanitize=...`, respectively. All check options supported by UndefinedBehaviorSanitizer can be found in [UBSan checks][ref-tool-sanitizer-undefined-checks]. To get nicer stack traces in error messages add `-fno-omit-frame-pointer` and `-g`. Note that the runtime behavior can be influenced by the `UBSAN_OPTIONS` environment variable.

For example, the following code contains a *signed integer overflow* error that should be detected by this sanitizer:

```c++
// ubsan_example.cpp
int main(int argc, char* argv[]) {
    int k = 0x7fffffff;
    k += argc;
    return 0;
}
```

Using the Clang compiler, the commands below can be utilized to compile and link with this sanitizer:

```sh
$ clang++ -fsanitize=undefined -g -fno-omit-frame-pointer ubsan_example.cpp
$ ./a.out
```

Please refer to the [UndefinedBehaviorSanitizer][ref-tool-sanitizer-undefined] and [GCC program instrumentation options][ref-gcc-instrumentation-options] pages for more details regarding this tool.

**Notes:**

- UndefinedBehaviorSanitizer checks have small runtime cost and no impact on address space layout or ABI.
- Supported by Clang and GCC compilers.

## References

- [Clang-format][ref-tool-clang-format]
- [Clang-format style options][ref-tool-clang-format-style-options]
- [Clang-tidy][ref-tool-clang-tidy]
- [Clang-tidy checks][ref-tool-clang-tidy-checks]
- [Doxygen][ref-tool-doxygen]
- [Address sanitizer][ref-tool-sanitizer-address]
- [Leak sanitizer][ref-tool-sanitizer-leak]
- [Memory sanitizer][ref-tool-sanitizer-memory]
- [Thread sanitizer][ref-tool-sanitizer-thread]
- [Undefined behavior sanitizer][ref-tool-sanitizer-undefined]
- [Undefined behavior sanitizer checks][ref-tool-sanitizer-undefined-checks]
- [GCC program instrumentation options][ref-gcc-instrumentation-options]
- [Visual Studio Code: C/C++ extension][ref-vscode-cpp-extension]

[ref-tool-clang-format]: https://clang.llvm.org/docs/ClangFormat.html "Clang-format"
[ref-tool-clang-format-style-options]: https://clang.llvm.org/docs/ClangFormatStyleOptions.html "Clang-format style options"
[ref-tool-clang-tidy]: https://clang.llvm.org/extra/clang-tidy/ "Clang-tidy"
[ref-tool-clang-tidy-checks]: https://clang.llvm.org/extra/clang-tidy/checks/list.html "Clang-tidy checks"
[ref-tool-doxygen]: https://www.doxygen.nl/ "Doxygen"
[ref-tool-sanitizer-address]: https://clang.llvm.org/docs/AddressSanitizer.html
[ref-tool-sanitizer-leak]: https://clang.llvm.org/docs/LeakSanitizer.html
[ref-tool-sanitizer-memory]: https://clang.llvm.org/docs/MemorySanitizer.html
[ref-tool-sanitizer-thread]: https://clang.llvm.org/docs/ThreadSanitizer.html
[ref-tool-sanitizer-undefined]: https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
[ref-tool-sanitizer-undefined-checks]: https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html#available-checks
[ref-gcc-instrumentation-options]: https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html
[ref-vscode-cpp-extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools "Visual Studio Code: C/C++ extension"
