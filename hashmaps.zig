const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // change the type: User -> *const User
    var lookup = std.StringHashMap(*const User).init(allocator);
    defer lookup.deinit();

    const goku = User{ .power = 9001 };

    // change type: goku -> &goku
    try lookup.put("Goku", &goku);

    //returns an optional, .? would panic if "Goku" wasn't in our hashmap
    // getPtr -> get
    const entry = lookup.get("Goku").?;
    // remember that thing.? is how you unwrap the potential null behind thing.

    std.debug.print("Goku's power is: {d}\n", .{entry.power});

    // returns true/false depending on if the item was removed
    _ = lookup.remove("Goku");
    // entry is a ptr to a shallow copy of the goku object residing in lookup
    // Better said, when we put goku into lookup, a copy of goku was made in
    // memory, and that shallow copy is now owned by lookup; the original goku
    // object remains and is still owned by main()
    //
    // Remember, the original goku object lives in the stack frame of main(),
    // it was not allocated onto the heap like lookup is.

    // now that entry is a pointer to the original object, the removal of goku
    // from lookup doesn't produce a dangling pointer (because entry got a ptr
    // to a valid address, and when that address is removed from lookup nothing
    // actually happens to the underlying address space or object residing
    // there).
    std.debug.print("Goku's power is: {d}\n", .{entry.power});
    std.debug.print("Goku's power is: {d}\n", .{goku.power});
}

const User = struct {
    power: i32,
};
