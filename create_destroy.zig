const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // create a User object (not an array) on the heap
    const user = try User.init(allocator, 1, 100);

    // free the memory allocated for the user at the end of the scope
    defer allocator.destroy(user);

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
    //
    // this first version only produces a dangling pointer.
    //fn init(id: u64, power: i32) *User{
    //    var user = User {
    //        .id = id,
    //        .power = power,
    //    };
    //    // this is a dangling pointer
    //    return &user;
    //}

    // here is the correct version:
    fn init(allocator: std.mem.Allocator, id: u64, power: i32) !*User {
        // create an object of type User on the heap somewhere; returns a ptr
        const user = try allocator.create(User);
        // the syntax here of user.* is how you dereference a ptr.
        // for a type T: &T => ptr to T; &T.* => T
        // think of it as "&T" == "Give me the address of T" and
        // "ptr.*" == "Give me the thingy in memory at address ptr"
        user.* = .{
            .id = id,
            .power = power,
        };
        return user;
    }
};
