const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

const GameData = struct {
    red: usize = 0,
    green: usize = 0,
    blue: usize = 0,
};

const colors = [_][]const u8{ "red", "green", "blue" };

fn parseGame(line: []const u8) !GameData {
    var res = GameData{};
    const start_idx = indexOf(u8, line, ':').? + 2;
    var round_iterator = splitSeq(u8, line[start_idx..], "; ");
    while (round_iterator.next()) |rnd| {
        var color_iterator = splitSeq(u8, rnd, ", ");
        while (color_iterator.next()) |pick| {
            blk: inline for (colors) |color| {
                if (std.mem.indexOf(u8, pick, color)) |idx| {
                    const count = try parseInt(usize, pick[0 .. idx - 1], 10);
                    if (@field(res, color) < count) {
                        @field(res, color) = count;
                    }
                    break :blk;
                }
            }
        }
    }
    return res;
}

pub fn main() !void {
    var games = [_]GameData{undefined} ** 100;
    var idx: usize = 0;
    var iterator = splitSca(u8, data, '\n');
    while (iterator.next()) |line| {
        games[idx] = try parseGame(line);
        idx += 1;
    }
    const pt1_red_limit: usize = 12;
    const pt1_green_limit: usize = 13;
    const pt1_blue_limit: usize = 14;
    var sum_pt1: usize = 0;
    var power_sum: usize = 0;
    for (games, 0..) |g, i| {
        power_sum += g.red * g.green * g.blue;
        if (g.red <= pt1_red_limit and g.green <= pt1_green_limit and g.blue <= pt1_blue_limit) {
            sum_pt1 += (i + 1);
        }
    }
    std.debug.print("Part 1: {d}\n", .{sum_pt1});
    std.debug.print("Part 2: {d}\n", .{power_sum});
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
