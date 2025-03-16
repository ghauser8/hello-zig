const std = @import("std");
// seeing how multi-dimensional arrays work in zig. This is super easy so you
// should just do this instead of whatever the hell you were trying to do
// with a generic returning a "matrix" object with methods and all that shit.
pub fn main() void {
    // var ma = [2][2]usize{ {1, 0}, {0, 1} };
    // this works; the above does not. Not sure.
    var ma: [2][2]usize = undefined;

    for (0..2) |i| {
        for (0..2) |j| {
            if (i == j) {
                ma[i][j] = 1;
            } else {
                ma[i][j] = 0;
            }
        }
    }
    std.debug.print("ma: {any}\n", .{ma});
}
