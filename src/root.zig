const std = @import("std");
const builtin = @import("builtin");

/// ANSI color codes and formatting
pub const codes = struct {
    // Regular colors
    pub const black = "\x1b[30m";
    pub const red = "\x1b[31m";
    pub const green = "\x1b[32m";
    pub const yellow = "\x1b[33m";
    pub const blue = "\x1b[34m";
    pub const magenta = "\x1b[35m";
    pub const cyan = "\x1b[36m";
    pub const white = "\x1b[37m";
    
    // Bright colors
    pub const bright_black = "\x1b[90m";
    pub const bright_red = "\x1b[91m";
    pub const bright_green = "\x1b[92m";
    pub const bright_yellow = "\x1b[93m";
    pub const bright_blue = "\x1b[94m";
    pub const bright_magenta = "\x1b[95m";
    pub const bright_cyan = "\x1b[96m";
    pub const bright_white = "\x1b[97m";
    
    // Background colors
    pub const bg_black = "\x1b[40m";
    pub const bg_red = "\x1b[41m";
    pub const bg_green = "\x1b[42m";
    pub const bg_yellow = "\x1b[43m";
    pub const bg_blue = "\x1b[44m";
    pub const bg_magenta = "\x1b[45m";
    pub const bg_cyan = "\x1b[46m";
    pub const bg_white = "\x1b[47m";
    
    // Text styles
    pub const bold = "\x1b[1m";
    pub const dim = "\x1b[2m";
    pub const italic = "\x1b[3m";
    pub const underline = "\x1b[4m";
    pub const blink = "\x1b[5m";
    pub const reverse = "\x1b[7m";
    pub const strikethrough = "\x1b[9m";
    
    // Reset
    pub const reset = "\x1b[0m";
};

/// Color support detection and management
pub const ColorSupport = struct {
    enabled: bool,
    
    /// Initialize color support detection
    pub fn init() ColorSupport {
        return ColorSupport{
            .enabled = detectColorSupport(),
        };
    }
    
    /// Detect if color output is supported
    fn detectColorSupport() bool {
        // Check if we're on a TTY
        const stdout_file = std.fs.File.stdout();
        if (!stdout_file.isTty()) {
            return false;
        }
        
        // Check environment variables
        if (std.process.getEnvVarOwned(std.heap.page_allocator, "NO_COLOR")) |_| {
            return false;
        } else |_| {}
        
        if (std.process.getEnvVarOwned(std.heap.page_allocator, "FORCE_COLOR")) |_| {
            return true;
        } else |_| {}
        
        if (std.process.getEnvVarOwned(std.heap.page_allocator, "TERM")) |term| {
            defer std.heap.page_allocator.free(term);
            if (std.mem.eql(u8, term, "dumb")) {
                return false;
            }
        } else |_| {}
        
        // On Windows, modern terminals support ANSI
        if (builtin.os.tag == .windows) {
            return true;
        }
        
        return true;
    }
    
    /// Apply color code to text if colors are enabled
    pub fn colorize(self: ColorSupport, color_code: []const u8, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        if (self.enabled) {
            return try std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ color_code, text, codes.reset });
        } else {
            return try allocator.dupe(u8, text);
        }
    }
    
    /// Print colored text directly to writer
    pub fn printColored(self: ColorSupport, writer: anytype, color_code: []const u8, comptime fmt: []const u8, args: anytype) !void {
        if (self.enabled) {
            try writer.print("{s}" ++ fmt ++ "{s}", .{color_code} ++ args ++ .{codes.reset});
        } else {
            try writer.print(fmt, args);
        }
    }
    
    // Convenience methods for common colors
    pub fn red(self: ColorSupport, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return self.colorize(codes.red, text, allocator);
    }
    
    pub fn green(self: ColorSupport, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return self.colorize(codes.green, text, allocator);
    }
    
    pub fn blue(self: ColorSupport, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return self.colorize(codes.blue, text, allocator);
    }
    
    pub fn yellow(self: ColorSupport, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return self.colorize(codes.yellow, text, allocator);
    }
    
    pub fn bold(self: ColorSupport, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return self.colorize(codes.bold, text, allocator);
    }
    
    // Convenience print methods
    pub fn printRed(self: ColorSupport, writer: anytype, comptime fmt: []const u8, args: anytype) !void {
        return self.printColored(writer, codes.red, fmt, args);
    }
    
    pub fn printGreen(self: ColorSupport, writer: anytype, comptime fmt: []const u8, args: anytype) !void {
        return self.printColored(writer, codes.green, fmt, args);
    }
    
    pub fn printBlue(self: ColorSupport, writer: anytype, comptime fmt: []const u8, args: anytype) !void {
        return self.printColored(writer, codes.blue, fmt, args);
    }
    
    pub fn printYellow(self: ColorSupport, writer: anytype, comptime fmt: []const u8, args: anytype) !void {
        return self.printColored(writer, codes.yellow, fmt, args);
    }
    
    pub fn printBold(self: ColorSupport, writer: anytype, comptime fmt: []const u8, args: anytype) !void {
        return self.printColored(writer, codes.bold, fmt, args);
    }
};

/// Simple color functions that always apply colors (no detection)
pub const simple = struct {
    pub fn colorize(color_code: []const u8, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return try std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ color_code, text, codes.reset });
    }
    
    pub fn red(text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return colorize(codes.red, text, allocator);
    }
    
    pub fn green(text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return colorize(codes.green, text, allocator);
    }
    
    pub fn blue(text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return colorize(codes.blue, text, allocator);
    }
    
    pub fn yellow(text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return colorize(codes.yellow, text, allocator);
    }
    
    pub fn bold(text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        return colorize(codes.bold, text, allocator);
    }
};

// Tests
test "color codes are correct" {
    try std.testing.expect(std.mem.eql(u8, codes.red, "\x1b[31m"));
    try std.testing.expect(std.mem.eql(u8, codes.reset, "\x1b[0m"));
}

test "simple colorization" {
    const allocator = std.testing.allocator;
    
    const red_text = try simple.red("test", allocator);
    defer allocator.free(red_text);
    
    try std.testing.expect(std.mem.startsWith(u8, red_text, codes.red));
    try std.testing.expect(std.mem.endsWith(u8, red_text, codes.reset));
    try std.testing.expect(std.mem.indexOf(u8, red_text, "test") != null);
}

test "color support detection" {
    const support = ColorSupport.init();
    // Just ensure it doesn't crash
    _ = support.enabled;
}
