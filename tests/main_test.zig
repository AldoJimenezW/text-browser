// work in progress
const std = @import("std");
const testing = std.testing;
const Config = @import("../src/core/config.zig").Config;

test "basic config" {
    var config = Config.init(testing.allocator);
    try testing.expect(config.workspaces_enabled);
}
