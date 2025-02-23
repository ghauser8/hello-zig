const std = @import("std");
const user = @import("models/user.zig");
const User = user.User;
const MAX_POWER = user.MAX_POWER;
// This code won't compile if `main` isn't `pub` (public)
pub fn main() void {
    // here we instantiated the struct with every field; this is required
    const user1 = User{
        .power = 9001,
        .name = "Goku",
    };
    // the symbols in the {}'s matter here; they specify the type that's to be
    //  formatted (s => str, d=> int of some variety).
    std.debug.print("{s}'s power is {d}\n", .{ user1.name, user1.power });
    std.debug.print("Max power is {d}\n", .{MAX_POWER});

    const sum = add(8999, 2);
    std.debug.print("8999 + 2 = {d}\n", .{sum});
    // methods of structs are called exactly as you'd expect
    user1.diagnose();
    // below is the 'under the hood' of the "syntactical sugar" seen above
    User.diagnose(user1);
}

fn add(a: i64, b: i64) i64 {
    return a + b;
    // interesting: a += b; return a; will not work because function parameters
    //  are constants
}
