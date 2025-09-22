const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the library
    const lib = b.addStaticLibrary(.{
        .name = "zig-color",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

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
}
