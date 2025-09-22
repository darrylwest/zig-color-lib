const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
<<<<<<< HEAD
    const optimize = b.standardOptimizeOption(.{});
=======
    // For libraries, optimization is typically handled by the consumer
    // It's also possible to define more custom flags to toggle optional features
    // of this build script using `b.option()`. All defined flags (including
    // target and optimize options) will be listed when running `zig build --help`
    // in this directory.
>>>>>>> main

    // Create the library
    const lib = b.addStaticLibrary(.{
        .name = "zig-color",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

<<<<<<< HEAD
    // Install the library
    b.installArtifact(lib);

    // Create a module that can be imported by other projects
    const color_module = b.addModule("zig-color", .{
        .root_source_file = b.path("src/root.zig"),
    });
    _ = color_module; // Suppress unused variable warning

    // Example executable to demonstrate usage
    const example = b.addExecutable(.{
        .name = "color-example",
        .root_source_file = b.path("example/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    example.root_module.addImport("zig-color", color_module);

    const example_install = b.addInstallArtifact(example, .{});
    const example_step = b.step("example", "Build and install the example");
    example_step.dependOn(&example_install.step);

    // Unit tests
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    // Documentation generation
    const docs = b.addStaticLibrary(.{
        .name = "zig-color",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const docs_step = b.step("docs", "Generate documentation");
    const install_docs = b.addInstallDirectory(.{
        .source_dir = docs.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&install_docs.step);
=======
    // Creates a test executable that will run `test` blocks from the module.
    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    // A run step that will run the test executable.
    const run_mod_tests = b.addRunArtifact(mod_tests);

    // A top level step for running all tests.
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_mod_tests.step);

    // Just like flags, top level steps are also listed in the `--help` menu.
    //
    // The Zig build system is entirely implemented in userland, which means
    // that it cannot hook into private compiler APIs. All compilation work
    // orchestrated by the build system will result in other Zig compiler
    // subcommands being invoked with the right flags defined. You can observe
    // these invocations when one fails (or you pass a flag to increase
    // verbosity) to validate assumptions and diagnose problems.
    //
    // Lastly, the Zig build system is relatively simple and self-contained,
    // and reading its source code will allow you to master it.
>>>>>>> main
}
