const std = @import("std");

pub fn main() void {
    // Here we'll blitz through the syntax of various control flows

    var i: u64 = 0;
    while (i < 5) {
        i += 1;
        if (i == 0) {
            std.debug.print("I found i = {d}\n", .{i});
        } else if (i == 1) {
            std.debug.print("This time I found i = {d}\n", .{i});
        } else {
            std.debug.print("I think i is something else: {d}\n", .{i});
        }
        for (0..3) |j| {
            std.debug.print("Here's j: {d}\n", .{j});
            if (j == 2) break;
        }
        std.debug.print("Greg == Greg is {}\n", .{std.mem.eql(u8, "Greg", "Greg")});
        std.debug.print("Greg == greg is {}\n", .{compare_strings(u8, "Greg", "greg")});
    }
}

pub fn compare_strings(comptime T: type, s1: []const T, s2: []const T) bool {
    // if they aren't the same length, they can't be equal
    if (s1.len != s2.len) return false;

    for (s1, s2) |s1_elem, s2_elem| {
        if (s1_elem != s2_elem) return false;
    }

    return true;
}

// There's more goodness to uncover, but for now let's move on with just these
// bare bones.
