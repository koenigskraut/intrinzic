const common = @import("common.zig");
const __m128d = common.__m128d;
const __m128i = common.__m128i;
const __m128 = common.__m128;

// addsubpd
pub inline fn _mm_addsub_pd(a: __m128d, b: __m128d) __m128d {
    return .{ a[0] - b[0], a[1] + b[1] };
}

// addsubps
pub inline fn _mm_addsub_ps(a: __m128, b: __m128) __m128 {
    const a_: [4]f32 = @bitCast(a);
    const b_: [4]f32 = @bitCast(b);
    var c: @Vector(4, f32) = undefined;
    inline for (a_, b_, 0..) |v0, v1, i| {
        c[i] = if (i & 1 == 0) v0 - v1 else v0 + v1;
    }
    return @bitCast(c);
}

// haddpd
pub inline fn _mm_hadd_pd(a: __m128d, b: __m128d) __m128d {
    return .{ a[0] + a[1], b[0] + b[1] };
}

// haddps
pub inline fn _mm_hadd_ps(a: __m128, b: __m128) __m128 {
    return .{
        a[0] + a[1], a[2] + a[3],
        b[0] + b[1], b[2] + b[3],
    };
}

// hsubpd
pub inline fn _mm_hsub_pd(a: __m128d, b: __m128d) __m128d {
    return .{ a[0] - a[1], b[0] - b[1] };
}

// hsubps
pub inline fn _mm_hsub_ps(a: __m128, b: __m128) __m128 {
    return .{
        a[0] - a[1], a[2] - a[3],
        b[0] - b[1], b[2] - b[3],
    };
}

// lddqu
pub inline fn _mm_lddqu_si128(mem_addr: *align(1) const __m128i) __m128i {
    return asm volatile (
        \\ lddqu  rdi, %xmm0
        : [ret] "={xmm0}" (-> __m128i),
        : [mem_addr] "{rdi}" (mem_addr),
    );
}

// movddup
pub inline fn _mm_loaddup_pd(mem_addr: *const f64) __m128d {
    return .{ mem_addr.*, mem_addr.* };
}

// movddup
pub inline fn _mm_movedup_pd(a: __m128d) __m128d {
    return .{ a[0], a[0] };
}

// movshdup
pub inline fn _mm_movehdup_ps(a: __m128) __m128 {
    return .{ a[1], a[1], a[3], a[3] };
}

// movsldup
pub inline fn _mm_moveldup_ps(a: __m128) __m128 {
    return .{ a[0], a[0], a[2], a[2] };
}

const testing = @import("std").testing;

fn expectApproxEqAbsVec(comptime T: type, a: T, b: T, comptime tolerance: comptime_float) !void {
    for (a, b) |v0, v1| {
        try testing.expectApproxEqAbs(v0, v1, tolerance);
    }
}

fn expectApproxEqRelVec(comptime T: type, a: T, b: T, comptime tolerance: comptime_float) !void {
    for (a, b) |v0, v1| {
        try testing.expectApproxEqRel(v0, v1, tolerance);
    }
}

test "sse3" {
    { // _mm_addsub_pd
        const a = __m128d{ 12.34, 56.78 };
        const b = __m128d{ 87.65, 43.21 };
        const c = _mm_addsub_pd(a, b);
        try expectApproxEqAbsVec([2]f64, .{ 12.34 - 87.65, 56.78 + 43.21 }, c, 0.001);
    }
    { // _mm_addsub_ps
        const a = __m128{ 1.2, 3.4, 5.6, 7.8 };
        const b = __m128{ 8.7, 6.5, 4.3, 2.1 };
        const c = _mm_addsub_ps(a, b);
        try expectApproxEqAbsVec([4]f32, .{
            1.2 - 8.7, 3.4 + 6.5,
            5.6 - 4.3, 7.8 + 2.1,
        }, c, 0.01);
    }
}
