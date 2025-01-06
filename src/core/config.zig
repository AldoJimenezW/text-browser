// Importing modules
const std = @import("std");

pub const Config = struct {
    // Basic config
    allocator: std.mem.Allocator,
    default_theme: Theme,
    workspaces_enabled: bool,
    
    pub const Theme = struct {
        is_eink: bool = false,
        // White Default background color
        background_color: u24 = 0xFFFFFF,
        // Black Default text color
        text_color: u24 = 0x000000,
    };

    pub fn init(allocator: std.mem.Allocator) Config {
        return .{
            .allocator = allocator,
            .default_theme = .{},
            .workspaces_enabled = true,
        };
    }
};
