# Code quality tools

This project uses many code quality tools commonly utilized in a C++ project. This document describes in more detail some of those tools.

## Table of contents

- [Clang-format](#clang-format)
- [Clang-tidy](#clang-tidy)
- [Doxygen](#doxygen)
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

Refer to the [clang-tidy page][ref-tool-clang-tidy] for more details regarding this tool.

## Doxygen

Doxygen is a documentation generator tool that automates the creation of documentation from source code comments, supporting C++, C, C#, Python, PHP, Java, Objective-C, Fortran, VHDL, Splice, IDL, and Lex code. The documentation can be generated in various output formats, such as HTML and PDF. Moreover, this tool is able to generate graphical representations of class hierarchies and collaboration diagrams, providing a visual overview of the relationships between classes and functions.

Doxygen supports many options which can be found using the `--help` option:

```sh
$ doxygen --help
```

This tool utilizes a configuration file (Doxyfile) that permits users to customize the documentation generation process, like the input files and the output format. This project uses this [doxygen configuration file](../doxygen/Doxyfile), which includes the desired options for this project, but can be used as example and be adjusted to your needs.

The format of the source code comments needs to follow some rules, in order to generate documentation from those comments by this tool.

Refer to the [Doxygen page][ref-tool-doxygen] for more details regarding this tool.

## References

- [Clang-format][ref-tool-clang-format]
- [Clang-format style options][ref-tool-clang-format-style-options]
- [Clang-tidy][ref-tool-clang-tidy]
- [Clang-tidy checks][ref-tool-clang-tidy-checks]
- [Doxygen][ref-tool-doxygen]
- [Visual Studio Code: C/C++ extension][ref-vscode-cpp-extension]

[ref-tool-clang-format]: https://clang.llvm.org/docs/ClangFormat.html "Clang-format"
[ref-tool-clang-format-style-options]: https://clang.llvm.org/docs/ClangFormatStyleOptions.html "Clang-format style options"
[ref-tool-clang-tidy]: https://clang.llvm.org/extra/clang-tidy/ "Clang-tidy"
[ref-tool-clang-tidy-checks]: https://clang.llvm.org/extra/clang-tidy/checks/list.html "Clang-tidy checks"
[ref-tool-doxygen]: https://www.doxygen.nl/ "Doxygen"
[ref-vscode-cpp-extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools "Visual Studio Code: C/C++ extension"
