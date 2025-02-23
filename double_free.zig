const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const arr = try allocator.alloc(usize, 4);
    allocator.free(arr);
    // a double-free!! this will cause a segfault (the program trying to access
    // memory it does not have access to; OS will abort the process and dump
    // the core. A bad time all around.
    allocator.free(arr);

    std.debug.print("This won't get printed\n", .{});
}
