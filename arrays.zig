const std = @import("std");

pub fn main() void {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    var end: usize = 4;
    end += 1;
    const b = a[1..end];
    std.debug.print("{any}\n", .{@TypeOf(b)});
    // if we try b[2] = 99; we'll get an error because we're trying to assign
    // to a const. this is because b is a slice, which means it'ss just pointing
    // to a, which is a const. A must be made var for that to work, and b (the slice)
    // can then be const or var itself.
    // The line b = b[1..]; will only work if b is declared as var, regardless
    // of what a is declared as.
}

// const a = [5]i32{ 1, 2, 3, 4, 5 };

// we already saw this .{..} syntax w- structs, works with arrays too
// const b: [5]i32 = .{ 1, 2, 3, 4, 5 };

// use _ to let the compiler infer the length
// const c = [_]i32{ 1, 2, 3, 4, 5 };

// this looks like a slice with length 3 and a pointer to a, but its not.
// We made the slice with valeus known at compile time, so the compiler got
// smart and made d a pointer to an array of integers with a length of 3.
// the type of d is *const [3]i32.
// const d = a[1..4];

// we can trick the compiler to give us a true slice with the following:
// var end: usize = 3;
// end += 1;
// const e = a[1..end];
// e is now a proper slice with type []const i32, where the length is a runtime
// property and the type is fully known at compile time.

// we can also slice to the end with
// const f = a[1..];
