const std = @import("std");

pub fn main() void {
    const A = [3][3]usize{
        [_]usize{ 1, 0, 0 },
        [_]usize{ 0, 1, 0 },
        [_]usize{ 0, 0, 1 },
    };

    const B = [3][3]usize{
        [_]usize{ 1, 2, 3 },
        [_]usize{ 4, 5, 6 },
        [_]usize{ 7, 8, 9 },
    };

    _ = A;
    _ = B;

    // for [0..3] |i| {
    //     for [0..3] |j| {
    //         for [0..3]

}
