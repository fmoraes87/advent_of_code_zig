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

        // try stdout.print("{s}\n", .{game_id_str});

        var game_id: i32 = try std.fmt.parseInt(i32, game_id_str[5..], 10);

        var subset_cubes = std.mem.split(u8, game_parts.next().?, ";");

        //Determine which games would have been possible if the bag had been loaded with only
        //12 red cubes, 13 green cubes, and 14 blue cubes

        var possible = true;

        while (subset_cubes.next()) |bag| {
            var cubes = std.mem.split(u8, bag, ",");
            var blue_qty: i32 = 14;
            var red_qty: i32 = 12;
            var green_qty: i32 = 13;
            while (cubes.next()) |cube| {
                //try stdout.print("Cube {s}\n", .{cube});
                const trimmed = std.mem.trim(u8, cube, " ");
                var cube_parts = std.mem.split(u8, trimmed, " ");
                var qty = try std.fmt.parseInt(i32, cube_parts.next().?, 10);
                var color = cube_parts.next().?;

                if (std.mem.eql(u8, color, "blue")) {
                    blue_qty -= qty;
                } else if (std.mem.eql(u8, color, "red")) {
                    red_qty -= qty;
                } else {
                    green_qty -= qty;
                }
            }

            if (blue_qty < 0 or red_qty < 0 or green_qty < 0) {
                possible = false;
            }
        }

        if (possible) {
            parcial_sum += game_id;
        }
    }

    try stdout.print("Answer {}", .{parcial_sum});
}
