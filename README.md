# Zig Color Library

```
 ______          ____      _              _     _ _     
|__  (_) __ _   / ___|___ | | ___  _ __  | |   (_) |__  
  / /| |/ _` | | |   / _ \| |/ _ \| '__| | |   | | '_ \ 
 / /_| | (_| | | |__| (_) | | (_) | |    | |___| | |_) |
/____|_|\__, |  \____\___/|_|\___/|_|    |_____|_|_.__/ 
        |___/                                           
```

A simple, efficient ANSI color library for Zig console applications. This library provides easy-to-use functions for adding colors and text formatting to terminal output with intelligent color support detection.

## Features

- 🎨 **Complete ANSI color support** - Regular and bright colors, background colors, and text styles
- 🧠 **Smart color detection** - Automatically detects terminal capabilities and respects `NO_COLOR`/`FORCE_COLOR` environment variables
- 🚀 **Multiple usage patterns** - Simple functions, smart detection, or direct ANSI codes
- 🔧 **Zero dependencies** - Pure Zig implementation with no external dependencies
- 📦 **Easy integration** - Simple module import and clean API
- ✅ **Well tested** - Comprehensive test suite included

## Quick Start

Add this library to your Zig project using the package manager:

```bash
zig fetch --save https://github.com/your-username/zig-color
```

Then import and use in your code:

```zig
const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Simple colored text
    const red_text = try color.simple.red("Error: Something went wrong!", allocator);
    defer allocator.free(red_text);
    std.debug.print("{s}\n", .{red_text});

    // Smart color support (respects terminal capabilities)
    const color_support = color.ColorSupport.init();
    const success_msg = try color_support.green("✅ Success!", allocator);
    defer allocator.free(success_msg);
    std.debug.print("{s}\n", .{success_msg});

    // Direct printing
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try color_support.printBlue(stdout, "Processing item {}\n", .{42});
    try stdout.flush();
}
```

## Usage Patterns

### 1. Direct ANSI Codes

For maximum control, use the raw ANSI escape codes:

```zig
const color = @import("zig-color");

// Print red text
std.debug.print("{s}Error message{s}\n", .{ color.codes.red, color.codes.reset });

// Combine styles
std.debug.print("{s}{s}Bold red warning{s}\n", .{
    color.codes.bold,
    color.codes.red,
    color.codes.reset
});
```

Available codes:
- **Colors**: `red`, `green`, `blue`, `yellow`, `cyan`, `magenta`, `white`, `black`
- **Bright colors**: `bright_red`, `bright_green`, `bright_blue`, etc.
- **Background**: `bg_red`, `bg_green`, `bg_blue`, etc.
- **Styles**: `bold`, `dim`, `italic`, `underline`, `blink`, `reverse`, `strikethrough`
- **Reset**: `reset` (always use this to return to normal formatting)

### 2. Simple Functions (Always Apply Colors)

Use the `simple` namespace for functions that always apply colors regardless of terminal support:

```zig
const color = @import("zig-color");

const allocator = std.heap.page_allocator;

// These always return colored text
const red_text = try color.simple.red("Error", allocator);
const green_text = try color.simple.green("Success", allocator);
const blue_text = try color.simple.blue("Info", allocator);
const yellow_text = try color.simple.yellow("Warning", allocator);
const bold_text = try color.simple.bold("Important", allocator);

// Don't forget to free the allocated strings
defer allocator.free(red_text);
defer allocator.free(green_text);
// ... etc
```

### 3. Smart Color Support

The `ColorSupport` struct automatically detects terminal capabilities and environment preferences:

```zig
const color = @import("zig-color");

const color_support = color.ColorSupport.init();

if (color_support.enabled) {
    std.debug.print("Terminal supports colors!\n", .{});
}

// These functions respect the color support detection
const smart_red = try color_support.red("Error", allocator);
const smart_green = try color_support.green("Success", allocator);

// Direct printing methods
try color_support.printRed(writer, "Error: {s}\n", .{"Something failed"});
try color_support.printGreen(writer, "Success: {} items processed\n", .{42});
```

### 4. Color Detection Behavior

The library automatically detects color support based on:

- **TTY detection**: Only enables colors when output is a terminal
- **Environment variables**:
  - `NO_COLOR` - Disables colors when set (respects the NO_COLOR standard)
  - `FORCE_COLOR` - Forces colors even in non-TTY environments
  - `TERM=dumb` - Disables colors for dumb terminals
- **Platform support**: Assumes modern Windows terminals support ANSI colors

## Building and Testing

```bash
# Build the library
zig build

# Run tests
zig build test

# Build and run the example
zig build example
./zig-out/bin/color-example

# Generate documentation
zig build docs
```

## Example Output

Running the included example produces output like this:

```
Direct red text        # (in red)
Direct bold text       # (in bold)
Always red text        # (in red)
Always green text      # (in green)
Color support is enabled!
Smart blue text        # (in blue, or plain if colors disabled)
This is printed red: 42         # (in red)
This is printed green: Hello!   # (in green)
This is printed bold: 3.14      # (in bold)
Bold Red Text          # (in bold red)
Underlined Cyan Text   # (underlined cyan)
```

## API Reference

### `codes` namespace

Contains all ANSI escape code constants as string literals.

### `simple` namespace

- `red(text, allocator)` - Always returns red text
- `green(text, allocator)` - Always returns green text
- `blue(text, allocator)` - Always returns blue text
- `yellow(text, allocator)` - Always returns yellow text
- `bold(text, allocator)` - Always returns bold text
- `colorize(color_code, text, allocator)` - Custom color with any ANSI code

### `ColorSupport` struct

- `init()` - Create with automatic color detection
- `colorize(color_code, text, allocator)` - Conditionally colorize text
- `red/green/blue/yellow/bold(text, allocator)` - Conditional color methods
- `printColored(writer, color_code, fmt, args)` - Direct conditional printing
- `printRed/printGreen/printBlue/printYellow/printBold(writer, fmt, args)` - Convenience print methods

## Requirements

- Zig 0.15.1 or later
- No external dependencies

## License

Apache 2.0 - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
