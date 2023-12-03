const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    var gear_map = std.AutoHashMap(usize, usize).init(gpa);
    defer gear_map.deinit();
    var p1: usize = 0;
    var p2: usize = 0;
    const pitch = std.mem.indexOf(u8, data, "\n").? + 1;
    var val: ?i64 = null;
    var val_start: ?usize = null;
    for (data, 0..) |char, i| {
        if (isDigit(char)) {
            if (val_start == null) val_start = i;
            val = (if (val) |v| v * 10 else 0) + (char - '0');
        } else if (val_start) |start| {
            const symbol: ?usize = find_symbol: for (start -| 1..i + 1) |j| {
                const above = if (j >= pitch) j - pitch else j;
                const along = j;
                const below = if (j + pitch < data.len) j + pitch else j;
                for ([_]usize{ above, along, below }) |k| {
                    if (data[k] != '.' and data[k] != '\n' and data[k] != '\r' and !isDigit(data[k])) {
                        break :find_symbol k;
                    }
                }
            } else null;

            if (symbol) |s| {
                const newval = parseInt(usize, data[start..i], 10) catch unreachable;
                p1 += newval;
                if (data[s] == '*') {
                    const gop = try gear_map.getOrPut(s);
                    if (gop.found_existing) {
                        p2 += gop.value_ptr.* * newval;
                        _ = gear_map.remove(s);
                    } else {
                        gop.value_ptr.* = newval;
                    }
                }
            }

            val_start = null;
            val = null;
        }
    }
    print("Part1: {d}\n", .{p1});
    print("Part2: {d}\n", .{p2});
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
const isDigit = std.ascii.isDigit;
// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
