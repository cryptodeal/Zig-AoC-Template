const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

const Part = enum { One, Two };

const numeric_strings = [_][]const u8{
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

pub fn main() !void {
    var pt1_sum: usize = 0;
    var pt2_sum: usize = 0;
    var iterator = splitSca(u8, data, '\n');
    while (iterator.next()) |line| {
        pt1_sum += firstCoord(line, .One) * 10 + lastCoord(line, .One);
        pt2_sum += firstCoord(line, .Two) * 10 + lastCoord(line, .Two);
    }
    print("Part1 Sum: {d}\n", .{pt1_sum});
    print("Part2 Sum: {d}\n", .{pt2_sum});
}

fn firstCoord(line: []const u8, part: Part) usize {
    var value: usize = 0;
    var min_idx: usize = std.math.maxInt(usize);
    if (part == .Two) {
        for (numeric_strings, 0..) |v, i| {
            if (std.mem.indexOf(u8, line, v)) |idx| {
                if (min_idx >= idx) {
                    min_idx = idx;
                    value = i % 10 + 1;
                }
            }
        }
    }
    if (indexOfAny(u8, line, "123456789")) |idx| {
        if (min_idx >= idx) {
            min_idx = idx;
            value = line[idx] - '0';
        }
    }
    return value;
}

fn lastCoord(line: []const u8, part: Part) usize {
    var value: usize = 0;
    var max_idx: usize = 0;
    if (part == .Two) {
        for (numeric_strings, 0..) |v, i| {
            if (std.mem.lastIndexOf(u8, line, v)) |idx| {
                if (max_idx <= idx) {
                    max_idx = idx;
                    value = i % 10 + 1;
                }
            }
        }
    }
    if (lastIndexOfAny(u8, line, "123456789")) |idx| {
        if (max_idx <= idx) {
            max_idx = idx;
            value = line[idx] - '0';
        }
    }
    return value;
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
