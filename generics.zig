const std = @import("std");
const Allocator = std.mem.Allocator;

//pub fn main() !void {
//    var arr: IntArray(3) = undefined;
//    arr[0] = 1;
//    arr[1] = 10;
//    arr[2] = 100;
//    std.debug.print("{any}\n", .{arr});
//}
//
//// note: the PascalCase of this function denotes that it returns a type
//// The comptime parameter length has to be known at compile time
//// Put it together: the type returned is a function of the compile-time known
//// length parameter.
//fn IntArray(comptime length: usize) type {
//    return [length]i64;
//}

// a consequence of this approach is that arr will have a type of IntArray(3),
// not a []i64 (cuz the length of the array it produces is defined by the
// function!
//
// We could re-do it like this to try to generalize the types a bit

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // change the stuff below
    var list = try List(u32).init(allocator);
    // we now get `generics.List(u32)`
    std.debug.print("{any}\n", .{@TypeOf(list)});
    defer list.deinit();

    for (0..10) |i| {
        // arr.items[i] = std.math.pow(i64, 10, @as(i64, @intCast(i)));
        try list.add(@intCast(i));
    }
    std.debug.print("{any}\n", .{list.items[0..list.pos]});
}

fn IntArray(comptime length: usize) type {
    return struct {
        items: [length]i64,

        fn init() IntArray(length) {
            return .{
                .items = undefined,
            };
        }
    };
}

// let's now jump to full-blown generics: the following will now produce a List
// object that will take on whatever type you need it to

fn List(comptime T: type) type {
    return struct {
        pos: usize,
        items: []T,
        allocator: Allocator,

        // we can also do this if our type name is obnoxiously long
        const Self = @This();
        // @This() evaluates to the innermost type from where it's called.

        fn init(allocator: Allocator) !Self {
            return .{
                .pos = 0,
                .allocator = allocator,
                .items = try allocator.alloc(T, 4),
            };
        }

        fn deinit(self: Self) void {
            self.allocator.free(self.items);
        }

        fn add(self: *Self, value: T) !void {
            const pos = self.pos;
            const len = self.items.len;

            if (pos == len) {
                // we've run out of space; create a new slice that's twice as
                // large
                var larger = try self.allocator.alloc(T, len * 2);

                // copy over the items we already had
                @memcpy(larger[0..len], self.items);
                // free the old list
                self.allocator.free(self.items);

                self.items = larger;
            }

            self.items[pos] = value;
            self.pos = pos + 1;
        }
    };
}
