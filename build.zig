const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("intrinzic", .{ .source_file = .{ .path = "src/root.zig" } });
}
