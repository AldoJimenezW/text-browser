const std = @import("std");
const Window = @import("gui/window.zig").Window;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var window = try Window.init();
    defer window.deinit();

    try window.run();
}