const std = @import("std");

pub fn main() !void {
    var buf: [150]u8 = undefined;
    var fa = std.heap.FixedBufferAllocator.init(&buf);

    // this will free all memory allocated with this allocator
    defer fa.reset();

    const allocator = fa.allocator();

    const json = try std.json.stringifyAlloc(allocator, .{
        .this_is = "an anonymous struct",
        .above = true,
        .last_param = "are options",
    }, .{ .whitespace = .indent_2 });

    // we can free this allocation, but since we know that our allocator is
    // a FixedBufferAllocator, we can rely on the above `defer fa.reset()`

    defer allocator.free(json);

    std.debug.print("{s}\n", .{json});
}
