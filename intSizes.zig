const std = @import("std");

pub fn main() void {
    std.debug.print("size of usize is {any}\n", .{@sizeOf(usize)});
    std.debug.print("int.bits of usize is {any}\n", .{@typeInfo(usize).int.bits});

    std.debug.print("size of i32 is {any}\n", .{@sizeOf(i32)});
    std.debug.print("int.bits of i32 is {any}\n", .{@typeInfo(i32).int.bits});
    std.debug.print("size of u32 is {any}\n", .{@sizeOf(u32)});
    std.debug.print("size of i64 is {any}\n", .{@sizeOf(i64)});
    std.debug.print("int.bits of i64 is {any}\n", .{@typeInfo(i64).int.bits});
}
