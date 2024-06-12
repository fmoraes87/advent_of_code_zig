const std = @import("std");
const fs = std.fs;

pub fn main() anyerror!void {
    const fname = "puzzle.txt";
    var f = try fs.cwd().openFile(fname, fs.File.OpenFlags{});
    defer f.close();
    var buf: [std.mem.page_size]u8 = undefined;
    const stdout = std.io.getStdOut().writer();

    var parcial_sum: i32 = 0;
    while (try f.reader().readUntilDelimiterOrEof(&buf, '\n')) |c| {
        var first_digit: ?i32 = null;
        var last_digit: ?i32 = null;

        for (c) |char| {
            if (std.ascii.isDigit(char)) {
                if (first_digit != null) {
                    last_digit = char - '0';
                } else {
                    first_digit = char - '0';
                }
            }
        }
        const num1 = (first_digit orelse 0) * 10;
        const final_num = num1 + (last_digit orelse (first_digit orelse 0));
        parcial_sum = parcial_sum + final_num;
    }

    try stdout.print("Answer {}", .{parcial_sum});
}
