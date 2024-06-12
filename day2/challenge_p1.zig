const std = @import("std");
const fs = std.fs;

pub fn main() anyerror!void {
    const fname = "puzzle.txt";
    var f = try fs.cwd().openFile(fname, fs.File.OpenFlags{});
    defer f.close();
    var buf: [std.mem.page_size]u8 = undefined;
    const stdout = std.io.getStdOut().writer();

    var parcial_sum: i32 = 0;
    while (try f.reader().readUntilDelimiterOrEof(&buf, '\n')) |c| {}

    try stdout.print("Answer {}", .{parcial_sum});
}
