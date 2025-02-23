// import std here
const std = @import("std");
pub const User = struct {
    power: u64 = 0, // fields can take default values
    name: []const u8, // structs always end w- a comma

    pub const SUPER_POWER = 9000;

    // struct methods need not have it's own type as a parameter
    pub fn init(name: []const u8, power: u64) User {
        return User{
            .name = name,
            .power = power,
        };
    }

    // we can be less explicit about types if desired; the following also works
    // pub fn init(name: []const u8, power: u64) User {
    //     return .{ // here we have `.` instead of the actual type Userd
    //         .name = name,
    //         .power = power,
    //     };
    // }

    pub fn diagnose(user: User) void {
        if (user.power >= SUPER_POWER) {
            std.debug.print("it's over {d}!!!\n", .{SUPER_POWER});
        }
    }
};

pub const MAX_POWER = 100_000;
