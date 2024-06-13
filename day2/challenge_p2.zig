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
        var game_id_str = game_parts.next().?;

        try stdout.print("{s}:", .{game_id_str});

        var subset_cubes = std.mem.split(u8, game_parts.next().?, ";");

        var blue_qty: i32 = 1;
        var red_qty: i32 = 1;
        var green_qty: i32 = 1;

        while (subset_cubes.next()) |bag| {
            var cubes = std.mem.split(u8, bag, ",");

            while (cubes.next()) |cube| {
                const trimmed = std.mem.trim(u8, cube, " ");
                var cube_parts = std.mem.split(u8, trimmed, " ");
                var cube_qty = cube_parts.next().?;

                var qty = try std.fmt.parseInt(i32, cube_qty, 10);
                var color = cube_parts.next().?;

                if (std.mem.eql(u8, color, "blue") and blue_qty < qty) {
                    blue_qty = qty;
                } else if (std.mem.eql(u8, color, "red") and red_qty < qty) {
                    red_qty = qty;
                } else if (std.mem.eql(u8, color, "green") and green_qty < qty) {
                    green_qty = qty;
                }
            }
        }

        try stdout.print("{},", .{red_qty});
        try stdout.print("{},", .{blue_qty});
        try stdout.print("{}\n", .{green_qty});

        parcial_sum += (blue_qty * red_qty * green_qty);
    }

    try stdout.print("Answer {}", .{parcial_sum});
}
