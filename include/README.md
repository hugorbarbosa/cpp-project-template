# C++ library API

When the C++ project is a library, this directory is usually present and contains the public header files, which are meant to be exposed to the users of the library.

Users of the library will include these headers in their own projects. The goal is that these headers define the interface that users interact with when using the library.

In addition, it is common to organize the public headers into a subdirectory named after your project or library (e.g., `include/my_library/`), which helps to avoid name conflicts with other libraries. For example, `include/my_library/my_class.h` would be a public header file.

Private header files, i.e., headers that are used only internally within the library's implementation, are not part of the public API and should not be exposed to the user. Therefore, those headers must not be present in this directory.
