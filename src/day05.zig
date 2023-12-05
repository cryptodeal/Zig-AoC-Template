const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

fn parseSeeds(allocator: std.mem.Allocator, d: []const u8) ![]usize {
    var seed_list = std.ArrayList(usize).init(allocator);
    const start_idx = indexOf(u8, d, ':').? + 1;
    var seed_iterator = splitSca(u8, d[start_idx..], ' ');
    while (seed_iterator.next()) |seed| {
        if (seed.len == 0) continue;
        try seed_list.append(try parseInt(usize, seed, 10));
    }
    return seed_list.toOwnedSlice();
}

const MapData = struct {
    src: usize = 0,
    dest: usize = 0,
    range: usize = 0,
};

fn parseMap(allocator: std.mem.Allocator, d: []const u8) ![]MapData {
    var map = std.ArrayList(MapData).init(allocator);
    var iterator = splitSca(u8, d, '\n');
    _ = iterator.first(); // first line is title of map
    var i: usize = 0;
    while (iterator.next()) |row| : (i += 1) {
        var row_iterator = splitSca(u8, row, ' ');
        try map.append(.{
            .dest = try parseInt(usize, row_iterator.first(), 10),
            .src = try parseInt(usize, row_iterator.next().?, 10),
            .range = try parseInt(usize, row_iterator.next().?, 10),
        });
    }
    return map.toOwnedSlice();
}

fn mapFrom(src: usize, map: []MapData) usize {
    var dest = src;
    for (map) |v| {
        if (v.src <= src and src <= v.src + v.range - 1) {
            const diff = src - v.src;
            dest = v.dest + diff;
            break;
        }
    }
    return dest;
}

const MapType = enum(usize) {
    Seed2Soil = 0,
    Soil2Fertilizer = 1,
    Fertilizer2Water = 2,
    Water2Light = 3,
    Light2Temp = 4,
    Temp2Humidity = 5,
    Humidity2Loc = 6,
};

fn mapSeedTo(src: usize, maps: []const []MapData, dest: MapType) usize {
    var out: usize = src;
    for (maps, 0..) |m, i| {
        if (i > @intFromEnum(dest)) break;
        out = mapFrom(out, m);
    }
    return out;
}

pub fn main() !void {
    var iterator = splitSeq(u8, data, "\n\n");
    const seeds = try parseSeeds(gpa, iterator.first());
    defer gpa.free(seeds);
    const maps: []const []MapData = &.{
        try parseMap(gpa, iterator.next().?),
        try parseMap(gpa, iterator.next().?),
        try parseMap(gpa, iterator.next().?),
        try parseMap(gpa, iterator.next().?),
        try parseMap(gpa, iterator.next().?),
        try parseMap(gpa, iterator.next().?),
        try parseMap(gpa, iterator.next().?),
    };
    defer for (maps) |m| gpa.free(m);
    var lowest_loc1: usize = std.math.maxInt(usize);
    for (seeds) |seed| {
        const loc = mapSeedTo(seed, maps, .Humidity2Loc);
        if (loc < lowest_loc1) lowest_loc1 = loc;
    }
    print("Part 1: {d}\n", .{lowest_loc1});

    var lowest_loc2: usize = std.math.maxInt(usize);
    var i: usize = 0;
    while (i < seeds.len) : (i += 2) {
        for (seeds[i]..seeds[i] + seeds[i + 1]) |seed| {
            const loc = mapSeedTo(seed, maps, .Humidity2Loc);
            if (loc < lowest_loc2) lowest_loc2 = loc;
        }
    }
    print("Part 2: {d}\n", .{lowest_loc2});
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
