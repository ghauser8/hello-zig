const std = @import("std");

// here's a bunch of code that won't compile:

//pub fn main() void {
//    // our first problem is this local variable is never mutated, even though
//    // it was declared with var (according to the compiler). A variable that is
//    // never mutated must be declared const
//    var user = User{
//        .id = 1,
//        .power = 100,
//    };
//
//    // we could try to trick the compiler by manually wiggling things around..
//    user.power += 0;
//
//    levelUp(user);
//    std.debug.print("User {d} has power of {d}\n", .{ user.id, user.power });
//}
//
//fn levelUp(user: User) void {
//    // our stunt of user.power += 0 above now produces an error here:
//    // cannot assign to constant.
//    // you might try the following..
//    var u = user;
//    u.power += 1;
//    // this now compiles but doesn't actually increment .power!!
//}
//
//// structs are similar to cpp structs; essentially a user-defined type.
//// Feels a lot like a class in python, especially since you can stick functions
//// (methods) in structs too.
//pub const User = struct {
//    id: u64,
//    power: i32,
//};

// lets try again, but now with pointers

pub fn main() void {
    var user = User{
        .id = 1,
        .power = 100,
    };
    // user.power += 0;

    const user_p = &user;
    std.debug.print("{any}\n", .{@TypeOf(user_p)});

    // the & operator is just like in cpp; it's the "addressOf" operator
    std.debug.print("{*}\n{*}\n{*}\n", .{ &user, &user.id, &user.power });
    // & returns a pointer to a value. The address of a value of type T is a
    // *T, said "a pointer to T".

    // levelUp(user);
    // now we pass the address of user, not a copy of user
    levelUp(&user);
    std.debug.print("User {d} has power of {d}\n", .{ user.id, user.power });
    // the above demonstrates that zig is passing copies of things to functions
    // This is guaranteed, and can be a nice thing to work with because you'll
    // always know that a called function never changes the thing you pass to it.
    // If you want a function you call to actually change the thing you're
    // passing to it, you'll need to use pointers.

}

// lets retry levelUp:
pub fn levelUp(user: *User) void {
    std.debug.print("levelUp: {*}\n", .{&user});
    user.power += 1;
}

pub const User = struct {
    id: u64,
    power: i32,
};

// there's much more to pointers, but the gist is they work just about
// identically to cpp pointers. The memory models are largely the same!
