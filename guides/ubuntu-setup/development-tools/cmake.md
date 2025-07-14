# CMake - Cross-Platform Build System Installation and Setup Guide

## Overview

**CMake** is an open-source, cross-platform family of tools designed to build, test, and package software. It controls the software compilation process using platform-independent configuration files and generates native makefiles and workspaces that can be used in the compiler environment of your choice.

### Key Features
- **Cross-platform**: Works on Linux, Windows, macOS, and many other platforms
- **Multiple generators**: Can generate Makefiles, Ninja, Visual Studio, Xcode projects
- **Modern C++ support**: Excellent support for C++11/14/17/20 features
- **Package management**: Integration with vcpkg, Conan, and other package managers
- **Testing framework**: Built-in CTest for running tests
- **Installation support**: CPack for creating installers

### Why Use CMake?
- Industry standard for C/C++ projects
- Excellent IDE integration
- Powerful dependency management
- Cross-platform compatibility
- Large ecosystem and community support
- Modern features and active development

## Installation

### Prerequisites
- C/C++ compiler (GCC, Clang, or MSVC)
- Make or Ninja build system

### Via Mise (Recommended)
```bash
# Install cmake via mise
mise use -g cmake

# Verify installation
cmake --version
```

### Manual Installation
```bash
# Install via package manager (may be older version)
sudo apt-get update
sudo apt-get install cmake

# Install latest version from Kitware's repository
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install cmake

# Install from source
wget https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1.tar.gz
tar -xzf cmake-3.28.1.tar.gz
cd cmake-3.28.1
./bootstrap
make -j$(nproc)
sudo make install
```

### Install Additional Tools
```bash
# Install build essentials
sudo apt-get install build-essential

# Install Ninja (faster than make)
sudo apt-get install ninja-build

# Install ccache for faster builds
sudo apt-get install ccache

# Install useful development tools
sudo apt-get install pkg-config git
```

### Verify Installation
```bash
# Check CMake version
cmake --version

# Check available generators
cmake --help

# Test basic functionality
mkdir test_cmake && cd test_cmake
echo 'cmake_minimum_required(VERSION 3.10)
project(test)
add_executable(test main.cpp)' > CMakeLists.txt
echo 'int main() { return 0; }' > main.cpp
cmake -B build
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias cm='cmake'
alias cmb='cmake --build'
alias cmi='cmake --install'
alias cmt='ctest'

# Useful functions
cmake_build() {
    local build_dir="${1:-build}"
    cmake -B "$build_dir" -DCMAKE_BUILD_TYPE=Release
    cmake --build "$build_dir" -j$(nproc)
}

cmake_debug() {
    local build_dir="${1:-build-debug}"
    cmake -B "$build_dir" -DCMAKE_BUILD_TYPE=Debug
    cmake --build "$build_dir" -j$(nproc)
}

cmake_clean() {
    local build_dir="${1:-build}"
    rm -rf "$build_dir"
    echo "Cleaned build directory: $build_dir"
}

# Quick project generator
cmake_init() {
    local project_name="${1:-MyProject}"
    local lang="${2:-CXX}"
    
    cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.16)
project($project_name)

set(CMAKE_${lang}_STANDARD 17)
set(CMAKE_${lang}_STANDARD_REQUIRED ON)

add_executable($project_name main.cpp)
EOF
    
    if [[ "$lang" == "CXX" ]]; then
        echo '#include <iostream>
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}' > main.cpp
    else
        echo '#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}' > main.c
    fi
    
    echo "Created CMake project: $project_name"
}
```

### Global Configuration
```bash
# Create global CMake configuration directory
mkdir -p ~/.cmake

# Create toolchain file for common settings
cat > ~/.cmake/global-settings.cmake << 'EOF'
# Global CMake settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Compiler-specific settings
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic")
endif()

# Build type specific settings
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
EOF

# Create presets file
cat > ~/.cmake/CMakeUserPresets.json << 'EOF'
{
    "version": 3,
    "configurePresets": [
        {
            "name": "default",
            "displayName": "Default Config",
            "description": "Default build using Ninja generator",
            "generator": "Ninja",
            "binaryDir": "${sourceDir}/build",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Release",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
            }
        },
        {
            "name": "debug",
            "displayName": "Debug Config",
            "description": "Debug build using Ninja generator", 
            "generator": "Ninja",
            "binaryDir": "${sourceDir}/build-debug",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Debug",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
            }
        }
    ],
    "buildPresets": [
        {
            "name": "default",
            "configurePreset": "default"
        },
        {
            "name": "debug", 
            "configurePreset": "debug"
        }
    ]
}
EOF
```

## Basic Usage

### Creating a Simple Project
```bash
# Create project structure
mkdir my_project && cd my_project

# Create main CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyProject VERSION 1.0.0)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add executable
add_executable(myapp src/main.cpp)

# Include directories
target_include_directories(myapp PRIVATE include)
EOF

# Create source structure
mkdir -p src include
echo '#include <iostream>
int main() {
    std::cout << "Hello, CMake!" << std::endl;
    return 0;
}' > src/main.cpp
```

### Building Projects
```bash
# Configure build (generate build files)
cmake -B build

# Build the project
cmake --build build

# Build with specific number of jobs
cmake --build build -j$(nproc)

# Build specific target
cmake --build build --target myapp

# Build with verbose output
cmake --build build --verbose
```

### Different Build Types
```bash
# Debug build
cmake -B build-debug -DCMAKE_BUILD_TYPE=Debug
cmake --build build-debug

# Release build
cmake -B build-release -DCMAKE_BUILD_TYPE=Release
cmake --build build-release

# Release with debug info
cmake -B build-relwithdebinfo -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build-relwithdebinfo

# Minimum size release
cmake -B build-minsizerel -DCMAKE_BUILD_TYPE=MinSizeRel
cmake --build build-minsizerel
```

## Advanced Usage

### Library Management
```bash
# Create library project
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyLibrary VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)

# Create static library
add_library(mylib STATIC
    src/library.cpp
    include/library.h
)

# Set include directories for library
target_include_directories(mylib
    PUBLIC 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        src
)

# Create executable that uses the library
add_executable(myapp src/main.cpp)
target_link_libraries(myapp PRIVATE mylib)

# Installation rules
install(TARGETS mylib myapp
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(DIRECTORY include/ DESTINATION include)
EOF
```

### External Dependencies
```bash
# Using find_package for system libraries
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyProject)

set(CMAKE_CXX_STANDARD 17)

# Find required packages
find_package(Threads REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(Boost REQUIRED COMPONENTS system filesystem)

add_executable(myapp src/main.cpp)

# Link libraries
target_link_libraries(myapp PRIVATE
    Threads::Threads
    OpenSSL::SSL
    OpenSSL::Crypto
    Boost::system
    Boost::filesystem
)
EOF

# Using FetchContent for downloading dependencies
cat > cmake/dependencies.cmake << 'EOF'
include(FetchContent)

# Fetch nlohmann/json
FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG v3.11.2
)

# Fetch spdlog
FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG v1.12.0
)

FetchContent_MakeAvailable(nlohmann_json spdlog)
EOF
```

### Testing with CTest
```bash
# Add testing to CMakeLists.txt
cat >> CMakeLists.txt << 'EOF'
# Enable testing
enable_testing()

# Add test executable
add_executable(tests test/test_main.cpp)
target_link_libraries(tests PRIVATE mylib)

# Register test
add_test(NAME unit_tests COMMAND tests)

# Add Google Test
find_package(GTest REQUIRED)
target_link_libraries(tests PRIVATE GTest::gtest_main)

# Discover tests automatically
include(GoogleTest)
gtest_discover_tests(tests)
EOF

# Run tests
ctest --build-config Release
ctest --verbose
ctest --parallel $(nproc)
```

### Cross-Compilation
```bash
# Create toolchain file for cross-compilation
cat > toolchain-arm.cmake << 'EOF'
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH /usr/arm-linux-gnueabihf)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
EOF

# Configure for cross-compilation
cmake -B build-arm -DCMAKE_TOOLCHAIN_FILE=toolchain-arm.cmake
cmake --build build-arm
```

### Custom Functions and Macros
```bash
# Create utility functions
cat > cmake/utils.cmake << 'EOF'
# Function to add compiler warnings
function(add_compiler_warnings target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        target_compile_options(${target} PRIVATE
            -Wall -Wextra -pedantic -Werror
            -Wconversion -Wsign-conversion
            -Wunused -Wuninitialized
        )
    endif()
endfunction()

# Function to set up code coverage
function(enable_coverage target)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${target} PRIVATE --coverage)
        target_link_libraries(${target} PRIVATE --coverage)
    endif()
endfunction()

# Macro to copy resources
macro(copy_resources target source_dir)
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${source_dir} $<TARGET_FILE_DIR:${target}>
    )
endmacro()
EOF
```

### Package Configuration
```bash
# Create package config files
cat > CMakeLists.txt << 'EOF'
# ... existing content ...

# Generate package config files
include(CMakePackageConfigHelpers)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/MyLibraryConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/MyLibraryConfig.cmake"
    INSTALL_DESTINATION lib/cmake/MyLibrary
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/MyLibraryConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MyLibraryConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/MyLibraryConfigVersion.cmake"
    DESTINATION lib/cmake/MyLibrary
)
EOF

# Create config template
mkdir -p cmake
cat > cmake/MyLibraryConfig.cmake.in << 'EOF'
@PACKAGE_INIT@

include("${CMAKE_CURRENT_LIST_DIR}/MyLibraryTargets.cmake")

check_required_components(MyLibrary)
EOF
```

## Integration Examples

### With Modern C++ Projects
```bash
# Modern C++ project structure
create_modern_cpp_project() {
    local project_name="$1"
    mkdir -p "$project_name"/{src,include,test,cmake,docs}
    
    cat > "$project_name/CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.20)
project($project_name VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Include custom CMake modules
list(APPEND CMAKE_MODULE_PATH "\${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Options
option(BUILD_TESTS "Build tests" ON)
option(BUILD_DOCS "Build documentation" OFF)

# Add main library
add_subdirectory(src)

# Add tests if enabled
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()

# Add documentation if enabled
if(BUILD_DOCS)
    add_subdirectory(docs)
endif()
EOF
    
    echo "Created modern C++ project: $project_name"
}
```

### With CI/CD Systems
```bash
# GitHub Actions CMake workflow
cat > .github/workflows/cmake.yml << 'EOF'
name: CMake Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        build_type: [Debug, Release]
        compiler: [gcc, clang]
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y cmake ninja-build
    
    - name: Configure CMake
      run: |
        cmake -B build -G Ninja \
          -DCMAKE_BUILD_TYPE=${{ matrix.build_type }} \
          -DCMAKE_C_COMPILER=${{ matrix.compiler == 'gcc' && 'gcc' || 'clang' }} \
          -DCMAKE_CXX_COMPILER=${{ matrix.compiler == 'gcc' && 'g++' || 'clang++' }}
    
    - name: Build
      run: cmake --build build
    
    - name: Test
      run: ctest --test-dir build --output-on-failure
EOF

# GitLab CI CMake configuration
cat > .gitlab-ci.yml << 'EOF'
stages:
  - build
  - test

variables:
  CMAKE_BUILD_TYPE: Release

build:
  stage: build
  image: ubuntu:latest
  before_script:
    - apt-get update && apt-get install -y cmake build-essential ninja-build
  script:
    - cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE
    - cmake --build build
  artifacts:
    paths:
      - build/

test:
  stage: test
  image: ubuntu:latest
  dependencies:
    - build
  script:
    - cd build && ctest --output-on-failure
EOF
```

### With Docker
```bash
# Multi-stage Dockerfile for CMake projects
cat > Dockerfile << 'EOF'
# Build stage
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build

# Runtime stage
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/myapp /usr/local/bin/

CMD ["myapp"]
EOF

# Docker Compose for development
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  cmake-dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/workspace
      - cmake-cache:/workspace/build
    working_dir: /workspace
    command: sleep infinity
    
volumes:
  cmake-cache:
EOF
```

### With IDEs
```bash
# VS Code configuration
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
{
    "cmake.buildDirectory": "${workspaceFolder}/build",
    "cmake.generator": "Ninja",
    "cmake.configureSettings": {
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
    },
    "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools",
    "files.associations": {
        "*.h": "cpp",
        "*.hpp": "cpp"
    }
}
EOF

cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/build/myapp",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "preLaunchTask": "cmake-build"
        }
    ]
}
EOF

cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "cmake-configure",
            "type": "shell",
            "command": "cmake",
            "args": ["-B", "build", "-G", "Ninja"],
            "group": "build"
        },
        {
            "label": "cmake-build",
            "type": "shell",
            "command": "cmake",
            "args": ["--build", "build"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "dependsOn": "cmake-configure"
        }
    ]
}
EOF
```

## Troubleshooting

### Common Issues

**Issue**: CMake version too old
```bash
# Solution: Install newer version from Kitware
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | sudo apt-key add -
sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install cmake

# Solution: Build from source
wget https://github.com/Kitware/CMake/releases/latest
```

**Issue**: Cannot find libraries
```bash
# Solution: Set CMAKE_PREFIX_PATH
cmake -B build -DCMAKE_PREFIX_PATH="/usr/local;/opt/local"

# Solution: Use pkg-config
find_package(PkgConfig REQUIRED)
pkg_check_modules(MYLIB REQUIRED mylib)

# Solution: Specify library paths explicitly
set(MYLIB_ROOT /path/to/library)
find_library(MYLIB_LIB mylib PATHS ${MYLIB_ROOT}/lib)
```

**Issue**: Compiler not found
```bash
# Solution: Specify compiler explicitly
cmake -B build -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++

# Solution: Use environment variables
export CC=clang
export CXX=clang++
cmake -B build
```

**Issue**: Build fails with cryptic errors
```bash
# Solution: Use verbose build
cmake --build build --verbose

# Solution: Check generated files
ls -la build/
cat build/CMakeCache.txt | grep ERROR
```

### Performance Tips
```bash
# Use Ninja instead of Make
cmake -B build -G Ninja

# Use ccache for faster rebuilds
cmake -B build -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

# Parallel builds
cmake --build build -j$(nproc)

# Precompiled headers (CMake 3.16+)
target_precompile_headers(myapp PRIVATE pch.h)
```

### Debugging CMake
```bash
# Enable debug output
cmake -B build --debug-output

# Print all variables
cmake -B build -LA

# Use message() for debugging
message(STATUS "Debug: CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}")
message(FATAL_ERROR "Stop here for debugging")

# Use cmake-gui for interactive debugging
sudo apt-get install cmake-qt-gui
cmake-gui
```

## Best Practices

### Project Structure
```bash
# Recommended project layout
my_project/
├── CMakeLists.txt          # Main CMake file
├── cmake/                  # CMake modules and utilities
│   ├── FindMyLib.cmake
│   └── utils.cmake
├── src/                    # Source files
│   ├── CMakeLists.txt
│   └── main.cpp
├── include/                # Public headers
│   └── myproject/
├── test/                   # Tests
│   ├── CMakeLists.txt
│   └── test_main.cpp
├── docs/                   # Documentation
├── external/               # Third-party dependencies
└── build/                  # Build directory (not in version control)
```

### Modern CMake Practices
```bash
# Use target-based approach
add_library(mylib src/library.cpp)
target_include_directories(mylib PUBLIC include)
target_compile_features(mylib PUBLIC cxx_std_17)

# Avoid global commands
# Don't use: include_directories(), link_directories(), add_definitions()
# Use target-specific commands instead

# Use generator expressions
target_compile_definitions(mylib PRIVATE 
    $<$<CONFIG:Debug>:DEBUG_BUILD>
    $<$<CONFIG:Release>:NDEBUG>
)

# Export compile commands for IDE integration
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

### Version and Compatibility
```bash
# Specify minimum required version
cmake_minimum_required(VERSION 3.16)

# Use version ranges for dependencies
find_package(Boost 1.70...1.80 REQUIRED)

# Check compiler features
target_compile_features(myapp PRIVATE cxx_std_17)
```

## Resources and References

- [CMake Official Website](https://cmake.org/)
- [CMake Documentation](https://cmake.org/documentation/)
- [Modern CMake Guide](https://cliutils.gitlab.io/modern-cmake/)
- [CMake Examples](https://github.com/ttroy50/cmake-examples)
- [Effective Modern CMake](https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1)
- [CMake GitHub Repository](https://github.com/Kitware/CMake)

This guide provides comprehensive coverage of CMake installation, configuration, and usage patterns for effective cross-platform C/C++ project building and management.