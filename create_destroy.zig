const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // create a User object (not an array) on the heap
    var user = try allocator.create(User);

    // free the memory allocated for the user at the end of the scope
    defer allocator.destroy(user);

    user.id = 1;
    user.power = 100;

    levelUp(user);
    std.debug.print("User {d} has power of {d}\n", .{ user.id, user.power });
}

// see that levelUp is expecting a pointer to a User. Above, user is the return
// of try allocator.create(User);, which is a pointer to a User type object
// that is now chilling somewhere in the heap. So this works.
fn levelUp(user: *User) void {
    user.power += 1;
}

pub const User = struct {
    id: u64,
    power: i32,

    // here is where we could try an init method that returns a pointer to a
    // new User object in the heap somewhere
};
