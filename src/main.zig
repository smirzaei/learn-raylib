const std = @import("std");
const rl = @import("raylib");

var counter = std.atomic.Value(usize).init(0);

pub fn main() !void {
    const width = 800;
    const height = 600;

    rl.initWindow(width, height, "Hello, world!");
    defer rl.closeWindow();

    rl.setTargetFPS(120);

    _ = try std.Thread.spawn(.{}, handleCounter, .{});

    while (!rl.windowShouldClose()) {
        _ = counter.fetchAdd(1, .seq_cst);
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.fromInt(0x6495ed));
        rl.drawFPS(0, 0);
    }
}

fn handleCounter() void {
    while (true) {
        const now = std.time.timestamp();
        const val = counter.load(.acquire);
        std.debug.print("time: {d} - count: {d}\n", .{ now, val });
        counter.store(0, .seq_cst);
        std.time.sleep(std.time.ns_per_s);
    }
}
