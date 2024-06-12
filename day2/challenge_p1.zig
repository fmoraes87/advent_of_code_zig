const std = @import("std");
const fs = std.fs;

pub fn main() anyerror!void {
    const fname = "puzzle.txt";
    var f = try fs.cwd().openFile(fname, fs.File.OpenFlags{});
    defer f.close();
    var buf: [std.mem.page_size]u8 = undefined;
    const stdout = std.io.getStdOut().writer();

    var parcial_sum: i32 = 0;
    while (try f.reader().readUntilDelimiterOrEof(&buf, '\n')) |game| {
        var game_parts = std.mem.split(u8, game, ":");
        var game_id = game_parts.next().?;
        try stdout.print("{s}\n", .{game_id});
        var subset_cubes = std.mem.split(u8, game_parts.next().?, ";");
        while (subset_cubes.next()) |bags| {
            var cubes = std.mem.split(u8, bags, ",");
            while (cubes.next()) |cube| {
                try stdout.print("Cube {s}\n", .{cube});
            }
        }
    }

    try stdout.print("Answer {}", .{parcial_sum});
}
