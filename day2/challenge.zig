const std = @import("std");
const fs = std.fs;
const StringHashMap = std.StringHashMap;

var allocator = std.heap.page_allocator;

fn startsWith(pointerToSlice: *[]const u8, prefix: []const u8) bool {
    const str: []const u8 = pointerToSlice.*;
    return std.mem.startsWith(u8, str, prefix);
}

pub fn main() anyerror!void {
    const fname = "../puzzle.txt";
    var f = try fs.cwd().openFile(fname, fs.File.OpenFlags{});
    defer f.close();

    var buf: [std.mem.page_size]u8 = undefined;
    const stdout = std.io.getStdOut().writer();

    var hashmap = StringHashMap(i32).init(allocator);
    //var hashmap = HashMap([]const u8, i32, hashString, stringEquals).init(allocator);
    defer hashmap.deinit(); //garante que a memoria seja liberada no final

    try hashmap.put("one", 1);
    try hashmap.put("two", 2);
    try hashmap.put("three", 3);
    try hashmap.put("four", 4);
    try hashmap.put("five", 5);
    try hashmap.put("six", 6);
    try hashmap.put("seven", 7);
    try hashmap.put("eight", 8);
    try hashmap.put("nine", 9);

    var parcial_sum: i32 = 0;
    var charList = std.ArrayList(u8).init(allocator);
    defer charList.deinit(); // Limpa a lista e a memória alocada quando terminar

    while (try f.reader().readUntilDelimiterOrEof(&buf, '\n')) |c| {
        var first_digit: ?i32 = null;
        var last_digit: ?i32 = null;

        for (c) |char| {
            if (std.ascii.isDigit(char)) {
                charList.clearAndFree();
                if (first_digit != null) {
                    last_digit = char - '0';
                } else {
                    first_digit = char - '0';
                }
            } else {
                try charList.append(char);
                const str = charList.items;
                try stdout.print("\n Partial string {s}", .{str});
                if (hashmap.get(str)) |value| {
                    try stdout.print("\n Number found {}", .{value});

                    if (first_digit != null) {
                        last_digit = value;
                    } else {
                        first_digit = value;
                    }

                    // Criando uma slice que exclui o primeiro caractere
                    const newSlice = charList.items[1..];

                    // Copiando a nova slice de volta para o charList
                    std.mem.copy(u8, charList.items, newSlice);

                    // Reduzindo o tamanho da lista
                    charList.resize(newSlice.len) catch unreachable;
                } else {
                    var found = false;
                    while (charList.items.len > 0) {
                        const str2 = charList.items;
                        try stdout.print("\n Partial string {s}", .{str2});
                        var it = hashmap.iterator();

                        while (it.next()) |entry| {
                            if (startsWith(entry.key_ptr, str2)) {
                                found = true;
                                break;
                            }
                        }

                        if (found) {
                            break;
                        }

                        // Criando uma slice que exclui o primeiro caractere
                        const newSlice = charList.items[1..];

                        // Copiando a nova slice de volta para o charList
                        std.mem.copy(u8, charList.items, newSlice);

                        // Reduzindo o tamanho da lista
                        charList.resize(newSlice.len) catch unreachable;
                    }

                    if (!found) {
                        charList.clearAndFree();
                    }
                }
            }
        }
        const num1 = (first_digit orelse 0) * 10;
        const final_num = num1 + (last_digit orelse (first_digit orelse 0));
        try stdout.print("\n Final number: {}", .{final_num});
        parcial_sum = parcial_sum + final_num;
    }

    try stdout.print("\n Answer {}", .{parcial_sum});
}
