const std = @import("std");

// the following demonstrates the concept of a null-terminated array.
// A null terminated array looks like `{'G','o','k','u',0}` in memory. The last
// value of 0 (\0) is the null terminator (sentinel).
//
// Strings are just null terminated arrays in zig. That type looks something like
// *const [4:0]u8
// a pointer to a null-terminated array of 4 bytes ([LENGTH:SENTINEL])
//
// "Goku" -> *const [4:0]u8 AND we can still assign it to a function paramter
//  and/or struct field of type []const u8! This is because zig will coerce
//  the type of a string literal (a null terminated array of fixed length) to
//  []const u8. this coersion is made cheap by the null terminator (no need to
//  iterate through the array representing the string literal to find the
//  sentinel)

pub fn main() void {

    // an array of 3 booleans with false as the sentinel value
    const a = [3:false]bool{ false, true, false };

    // this line is more advanced, and is not going to get explained!
    std.debug.print("{any}\n", .{std.mem.asBytes(&a).*});
}
