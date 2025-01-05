// tests/main_test.zig
const std = @import("std");
const testing = std.testing;
const Config = @import("../src/core/config.zig").Config;

test "configuración básica" {
    var config = Config.init(testing.allocator);
    try testing.expect(config.workspaces_enabled);
}
