// src/core/config.zig
const std = @import("std");

pub const Config = struct {
    // Configuraciones básicas
    allocator: std.mem.Allocator,
    default_theme: Theme,
    workspaces_enabled: bool,
    
    pub const Theme = struct {
        is_eink: bool = false,
        background_color: u24 = 0xFFFFFF, // blanco por defecto
        text_color: u24 = 0x000000,      // negro por defecto
    };

    pub fn init(allocator: std.mem.Allocator) Config {
        return .{
            .allocator = allocator,
            .default_theme = .{},
            .workspaces_enabled = true,
        };
    }
};
