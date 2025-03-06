const std = @import("std");

// ArenaAllocator: good for short-lived state that can be safely discarded
// after use.

// A skeleton parser function:

fn parse(allcoator: Allocator, input: []const u8) !Something {
    // here we're using just a normal general purpose allocator
    const state = State{
        .buf = try allocator.alloc(u8, 512),
        .nesting = try allocator.alloc(NestType, 10),
    };
    // deferring the freeing that's needed for the parser
    defer allocator.free(state.buf);
    defer allocator.free(state.nesting);

    // The trick occurs here: what if parseInternal needs another short lived 
    // allocation? How many need to be chained together like this? as that 
    // chaining scales, managing all the individual allocations may get hard.
    return parseInternal(allocator, state, input);
}


// instead, we can use arena allocators, which allows for freeing everything 
// in "one shot"

fn parse(allocator: Allocator, input []const u8) !Something {
    // create an ArenaAllocator from the supplied allocator
    var arena = std.heap.ArenaAllocator.init(allocator);

    // this will free anything created from this arean
    defer arena.deinit();

    // create an std.mem.Allocator from the arena, this will be the allocator
    // we'll use internally
    const aa = arena.allocator();
    
    const state = State{
        // we're using aa here!
        .buf = try aa.alloc(u8,512),

        // we're using aa here!
        .nesting = try aa.alloc(NestType, 10),
    };

    // we're passing aa here, so we're guaranteed that any other allocation
    // will be in our arena
    return parseInternal(aa, state, input);
}


