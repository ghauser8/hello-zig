const std = @import("std");
const Allocator = std.mem.Allocator;

// the following code is "fine". dest is a runtime allocated array that will
// contain the lower case version of str. Any usage of this code would require
// freeing the references to dest
fn allocLower(allocator: Allocator, str: []const u8) ![]const u8 {
    var dest = try allocator.alloc(u8, str.len);

    for (str, 0..) |c, i| {
        dest[i] = switch (c) {
            'A'...'Z' => c + 32,
            else => c,
        };
    }

    return dest;
}

// For this specific code, we should have used std.ascii.eqlIgnoreCase
// The following is dangerous:
fn isSpecial(allocator: Allocator, name: []const u8) !bool {
    const lower = try allocLower(allocator, name);
    return std.mem.eql(u8, lower, "admin");
}
// isSpecial will cause a memory leak because the memory allocated in
// allocLower is never freed. Once isSpecial returns, that memory can never
// be freed! When isSpecial returns, we lose all references to the allocated
// memory.
