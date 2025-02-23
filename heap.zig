const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    // heap memory allocators
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // These are zig-specific lines:
    // first is to allocate heap memory at runtime.
    var arr = try allocator.alloc(usize, try getRandomCount());
    // next we free the memory we just allocated, but NOT immediately.
    // the defer keyword will make sure that the code that follows it is only
    // executed on scope exit (reaching the end of the scope the defer keyword
    // is actually in or returning from that same scope).
    // Note that defer isn't exclusively for memory management, you can use it
    // with any arbitrary code that you want executed at scope exit.
    defer allocator.free(arr);

    for (0..arr.len) |i| {
        arr[i] = i;
    }
    std.debug.print("{any}\n", .{arr});
}

fn getRandomCount() !u8 {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    var random = std.Random.DefaultPrng.init(seed);
    return random.random().uintAtMost(u8, 5) + 5;
}

// below is an example of using errdefer, which only executes the code on
// scope exit in the event of an error occuring within the same scope.
//
// this is also not exactly how one would do something like this; I mangled it
// so the compiler wouldn't complain.

pub const Game = struct {
    players: []usize,
    history: []usize,
    allocator: Allocator,

    fn init(allocator: Allocator, player_count: usize) !Game {
        const players = try allocator.alloc(usize, player_count);
        errdefer allocator.free(players);

        // store 10 most recent moves per player
        const history = try allocator.alloc(usize, player_count * 10);

        return .{
            .players = players,
            .history = history,
            .allocator = allocator,
        };
    }

    fn deinit(game: Game) void {
        const allocator = game.allocator;
        allocator.free(game.players);
        allocator.free(game.history);
    }
};
