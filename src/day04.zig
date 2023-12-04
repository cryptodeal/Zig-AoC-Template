const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

const CardInfo = struct {
    winning_numbers: []usize,
    numbers: []usize,
};

fn parseCard(allocator: std.mem.Allocator, line: []const u8) !CardInfo {
    const idx = indexOf(u8, line, ':').? + 1;
    var iter = splitSca(u8, line[idx..], '|');
    const winning_numbers = iter.first();
    var winners = std.ArrayList(usize).init(allocator);
    var num_iter = splitSca(u8, winning_numbers, ' ');
    while (num_iter.next()) |num| {
        if (num.len == 0) continue;
        try winners.append(try parseInt(usize, num, 10));
    }
    const numbers = iter.next().?;
    var nums = std.ArrayList(usize).init(allocator);
    num_iter = splitSca(u8, numbers, ' ');
    while (num_iter.next()) |num| {
        if (num.len == 0) continue;
        try nums.append(try parseInt(usize, num, 10));
    }
    return .{
        .winning_numbers = try winners.toOwnedSlice(),
        .numbers = try nums.toOwnedSlice(),
    };
}

fn calcMatches(info: CardInfo) usize {
    var matches: usize = 0;
    for (info.numbers) |num| {
        if (indexOf(usize, info.winning_numbers, num)) |_| matches += 1;
    }
    return matches;
}

pub fn main() !void {
    var cards = [_]CardInfo{undefined} ** 220;
    var card_counts = [_]usize{1} ** 220;
    defer for (cards) |c| {
        gpa.free(c.winning_numbers);
        gpa.free(c.numbers);
    };
    var iter = splitSca(u8, data, '\n');
    var i: usize = 0;
    while (iter.next()) |line| : (i += 1) {
        cards[i] = try parseCard(gpa, line);
    }
    var pt1: usize = 0;
    var pt2: usize = 0;
    for (cards, 0..) |c, idx| {
        pt2 += card_counts[idx];
        const match_count = calcMatches(c);
        var score: usize = 0;
        for (0..match_count) |y| {
            if (y == 1) score = 1 else score *= 2;
        }
        pt1 += score;
        for (card_counts[idx + 1 .. idx + 1 + match_count]) |*count| {
            count.* += 1 * card_counts[idx];
        }
    }
    print("Part 1: {d}\n", .{pt1});
    print("Part 2: {d}\n", .{pt2});
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
