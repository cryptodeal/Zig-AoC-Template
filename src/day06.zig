const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

const RaceData = struct { time: usize = undefined, dist: usize = undefined };

fn parseData(d: []const u8) ![4]RaceData {
    const newline_idx = indexOf(u8, d, '\n').?;
    var times_iterator = splitSca(u8, d[0..newline_idx], ' ');
    _ = times_iterator.first();
    var res = [_]RaceData{.{}} ** 4;
    var i: usize = 0;
    while (times_iterator.next()) |t| {
        if (t.len == 0) continue;
        res[i].time = try parseInt(usize, t, 10);
        i += 1;
    }
    var dists_iterator = splitSca(u8, d[newline_idx + 1 ..], ' ');
    _ = dists_iterator.first();
    i = 0;
    while (dists_iterator.next()) |t| {
        if (t.len == 0) continue;
        res[i].dist = try parseInt(usize, t, 10);
        i += 1;
    }
    return res;
}

fn parseData2(allocator: std.mem.Allocator, d: []const u8) !RaceData {
    var time = std.ArrayList(u8).init(allocator);
    defer time.deinit();
    const newline_idx = indexOf(u8, d, '\n').?;
    var times_iterator = splitSca(u8, d[0..newline_idx], ' ');
    _ = times_iterator.first();
    while (times_iterator.next()) |t| {
        if (t.len == 0) continue;
        try time.appendSlice(t);
    }
    var dist = std.ArrayList(u8).init(allocator);
    defer dist.deinit();
    var dists_iterator = splitSca(u8, d[newline_idx + 1 ..], ' ');
    _ = dists_iterator.first();
    while (dists_iterator.next()) |t| {
        if (t.len == 0) continue;
        try dist.appendSlice(t);
    }
    return .{ .time = try parseInt(usize, time.items, 10), .dist = try parseInt(usize, dist.items, 10) };
}

fn calcWinnerRange(d: usize, t: usize) [2]usize {
    const fd: f64 = @floatFromInt(d);
    const ft: f64 = @floatFromInt(t);
    const min_float = (ft - @sqrt(std.math.pow(f64, ft, 2) - 4 * fd)) / 2;
    const max_float = (ft + @sqrt(std.math.pow(f64, ft, 2) - 4 * fd)) / 2;
    const min: usize = if (std.math.modf(min_float).fpart == 0) @intFromFloat(min_float + 1) else @intFromFloat(std.math.modf(min_float).ipart + 1);
    const max: usize = if (std.math.modf(min_float).fpart == 0) @intFromFloat(max_float - 1) else @intFromFloat(std.math.modf(max_float).ipart);
    return [2]usize{ min, max };
}

pub fn main() !void {
    const parsed = try parseData(data);
    var pt1: usize = 0;
    for (parsed) |race| {
        const methods = calcWinnerRange(race.dist, race.time);
        const count = (methods[1] - methods[0]) + 1;
        if (pt1 == 0) pt1 = count else pt1 *= count;
    }
    print("Part 1: {d}\n", .{pt1});
    const parsed_2 = try parseData2(gpa, data);
    const pt2_methods = calcWinnerRange(parsed_2.dist, parsed_2.time);
    print("Part 2: {d}\n", .{(pt2_methods[1] - pt2_methods[0]) + 1});
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
