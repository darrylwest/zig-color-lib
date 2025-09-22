const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();
    const color_support = color.ColorSupport.init();

    // Method 1: Direct color codes
    try stdout.print("{s}Direct red text{s}\n", .{ color.codes.red, color.codes.reset });
    try stdout.print("{s}Direct bold text{s}\n", .{ color.codes.bold, color.codes.reset });

    // Method 2: Using simple functions (always colors)
    const simple_red = try color.simple.red("Always red text", allocator);
    defer allocator.free(simple_red);
    try stdout.print("{s}\n", .{simple_red});

    const simple_green = try color.simple.green("Always green text", allocator);
    defer allocator.free(simple_green);
    try stdout.print("{s}\n", .{simple_green});

    // Method 3: Using ColorSupport (respects terminal capabilities)
    if (color_support.enabled) {
        try stdout.print("Color support is enabled!\n", .{});
    } else {
        try stdout.print("Color support is disabled.\n", .{});
    }

    const smart_blue = try color_support.blue("Smart blue text", allocator);
    defer allocator.free(smart_blue);
    try stdout.print("{s}\n", .{smart_blue});

    // Method 4: Direct printing with ColorSupport
    try color_support.printRed(stdout, "This is printed red: {}\n", .{42});
    try color_support.printGreen(stdout, "This is printed green: {s}\n", .{"Hello!"});
    try color_support.printBold(stdout, "This is printed bold: {d:.2}\n", .{3.14159});

    // Demonstrate multiple styles
    try stdout.print("{s}{s}Bold Red Text{s}\n", .{ color.codes.bold, color.codes.red, color.codes.reset });
    try stdout.print("{s}{s}Underlined Cyan Text{s}\n", .{ color.codes.underline, color.codes.cyan, color.codes.reset });
}
