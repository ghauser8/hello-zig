const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
    // CL app that collects user-entered names and then reports if "Leto" was
    // added.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var lookup = std.StringHashMap(User).init(allocator);
    // we now need to replace this so that we can clean up our keys effectively
    // defer lookup.deinit();

    defer {
        var it = lookup.keyIterator();
        while (it.next()) |key| {
            allocator.free(key.*);
        }
        lookup.deinit();
    }
    // remember that defer will run any block of code (curly braces) upon
    // exit of current scope.

    // stdin is a std.io.Reader
    // the opposite of an std.io.Writer, which we already saw
    const stdin = std.io.getStdIn().reader();

    //stdout is an std.io.Writer
    const stdout = std.io.getStdOut().writer();

    var i: i32 = 0;
    var buf: [30]u8 = undefined;
    while (true) : (i += 1) {
        // having our buffer variable (that stores the user input) defined here
        // means our key values are outlived by the hashmap they're supposed to
        // be stored in!
        // Every time we go through the while loop, we create a new buf, pass
        // it's address to stdin.read(), then try to put it in the hashmap.
        // Moving buf to outside the whie loop doesn't solve the problem,
        // because we'll just be overwriting the key values on subsequent loops
        try stdout.print("Please enter a name: ", .{});
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            var name = line;
            if (builtin.os.tag == .windows) {
                // In Windows lines are terminated by \r\n.
                // We need to strip out the \r
                name = @constCast(std.mem.trimRight(u8, name, "\r"));
            }
            if (name.len == 0) {
                break;
            }
            // to fix our keys, we need to make sure they live long enough;
            // to the heap!!
            // try lookup.put(name, .{ .power = i });
            const owned_name = try allocator.dupe(u8, name);
            try lookup.put(owned_name, .{ .power = i });
            // dupe is a method of std.mem.Allocator. Allocates a duplicate of
            // the given value. This now means our keys outlive the hashmap,
            // but we're also leaking!
        }
    }
    // Even if user actually types "Leto", contains always returns false!
    // some debug:
    var it = lookup.iterator();
    while (it.next()) |kv| {
        std.debug.print("{s} == {any}\n", .{ kv.key_ptr.*, kv.value_ptr.* });
    }
    // the above while loop produces
    //      == ownership.User{ .power = i }
    // for every key passed by the user.
    const has_leto = lookup.contains("Leto");
    std.debug.print("{any}\n", .{has_leto});
}

const User = struct {
    power: i32,
};
