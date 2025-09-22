# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Zig color library project designed as a pure library module:
- A library module (`color_lib`) that can be consumed by other Zig packages
- No executable - focused purely on providing reusable color manipulation functionality

The project follows standard Zig 0.15.1+ conventions with module-based architecture.

## Key Build Commands

- `zig build` - Build the library module
- `zig build test` - Run library tests
- `zig build --help` - Show all available build options and steps

## Architecture

The codebase is structured as follows:

- `src/root.zig` - Library root module entry point, exposes public API for the `color_lib` module
- `build.zig` - Build configuration defining the library module
- `build.zig.zon` - Package manifest with dependencies and metadata

### Module Design

The project defines a `color_lib` module in build.zig that:
- Uses `src/root.zig` as its root source file
- Is designed to be imported by consumers as `@import("color_lib")`
- Contains the core color manipulation functionality

The module is designed to be imported by other Zig projects as a dependency.

## Development Notes

- The project requires minimum Zig version 0.15.1
- Currently contains placeholder functionality (basic add function with tests)
- Build system supports parallel test execution for both module and executable tests
- No external dependencies are currently defined in build.zig.zon