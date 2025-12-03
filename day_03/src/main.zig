const std = @import("std");

fn joltage(batteries: []const u8, comptime length: usize) usize {
    var best = [_]u8{'0'} ** length;

    for (batteries) |value| {
        for (0..length - 1) |i| {
            if (best[i] < best[i + 1]) {
                best[i] = best[i + 1];
                best[i + 1] = 0;
            }
        }
        if (best[length - 1] < value) {
            best[length - 1] = value;
        }
    }

    var res: usize = 0;
    for (best) |v| {
        res = res * 10 + (v - '0');
    }

    return res;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer if (gpa.deinit() == .leak) {
        std.log.err("Memory leak", .{});
    };

    var argsIterator = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argsIterator.deinit();

    // Skip executable
    _ = argsIterator.next();

    const input_file = argsIterator.next() orelse "example";

    const content = try std.fs.cwd().readFileAlloc(allocator, input_file, std.math.maxInt(usize));
    defer allocator.free(content);

    var lines = std.mem.splitScalar(u8, content, '\n');
    var sum_1: usize = 0;
    var sum_2: usize = 0;
    while (lines.next()) |line| {
        sum_1 += joltage(line, 2);
        sum_2 += joltage(line, 12);
    }

    var buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&buf);
    try stdout.interface.print("Part 1: {}\n", .{ sum_1 });
    try stdout.interface.print("Part 2: {}\n", .{ sum_2 });
    try stdout.interface.flush();
}
