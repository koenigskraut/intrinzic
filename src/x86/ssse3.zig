const common = @import("common.zig");
const comptimePrint = @import("std").fmt.comptimePrint;
const __m128i = common.__m128i;
const __m64 = common.__m64;

// pabsw
pub inline fn _mm_abs_epi16(a: __m128i) __m128i {
    const b: @Vector(8, i16) = @bitCast(a);
    return @bitCast(@abs(b));
}

// pabsd
pub inline fn _mm_abs_epi32(a: __m128i) __m128i {
    const b: @Vector(4, i32) = @bitCast(a);
    const c = @abs(b);
    return @bitCast(c);
}

// pabsb
pub inline fn _mm_abs_epi8(a: __m128i) __m128i {
    const b: @Vector(16, i8) = @bitCast(a);
    const c = @abs(b);
    return @bitCast(c);
}

// pabsw
pub inline fn _mm_abs_pi16(a: __m64) __m64 {
    const b: @Vector(4, i16) = @bitCast(a);
    const c = @abs(b);
    return @bitCast(c);
}

// pabsd
pub inline fn _mm_abs_pi32(a: __m64) __m64 {
    const b: @Vector(2, i32) = @bitCast(a);
    const c = @abs(b);
    return @bitCast(c);
}

// pabsb
pub inline fn _mm_abs_pi8(a: __m64) __m64 {
    const b: @Vector(8, i8) = @bitCast(a);
    const c = @abs(b);
    return @bitCast(c);
}

// palignr
pub inline fn _mm_alignr_epi8(a: __m128i, b: __m128i, comptime imm8: u8) __m128i {
    comptime var vec: [16]i32 = undefined;
    switch (imm8) {
        inline 0...15 => {
            comptime {
                for (0..16, imm8..) |i, v|
                    vec[i] = if (v < 16) @intCast(v) else ~@as(i32, @intCast(v - 16));
            }
            const a0: @Vector(16, i8) = @bitCast(a);
            const b0: @Vector(16, i8) = @bitCast(b);
            const c = @shuffle(i8, b0, a0, vec);
            return @bitCast(c);
        },
        inline 16...31 => {
            comptime {
                for ((imm8 - 16)..imm8, 0..) |v, i|
                    vec[i] = if (v < 16) v else ~@as(i32, @intCast(v - 16));
            }
            const a0: @Vector(16, i8) = @bitCast(a);
            const b0: @Vector(16, i8) = @splat(0);
            const c = @shuffle(i8, a0, b0, vec);
            return @bitCast(c);
        },
        inline else => return @splat(0),
    }
}

// palignr
pub inline fn _mm_alignr_pi8(a: __m64, b: __m64, comptime imm8: u8) __m64 {
    return asm volatile (comptimePrint("palignr ${d}, %[b], %[a]", .{imm8})
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// phaddw
pub inline fn _mm_hadd_epi16(a: __m128i, b: __m128i) __m128i {
    const a0: @Vector(8, u16) = @bitCast(a);
    const b0: @Vector(8, u16) = @bitCast(b);
    const a1 = @Vector(8, u16){ a0[0], a0[2], a0[4], a0[6], b0[0], b0[2], b0[4], b0[6] };
    const b1 = @Vector(8, u16){ a0[1], a0[3], a0[5], a0[7], b0[1], b0[3], b0[5], b0[7] };
    const c = a1 +% b1;
    return @bitCast(c);
}

// phaddd
pub inline fn _mm_hadd_epi32(a: __m128i, b: __m128i) __m128i {
    const a0: @Vector(4, u32) = @bitCast(a);
    const b0: @Vector(4, u32) = @bitCast(b);
    const a1 = @Vector(4, u32){ a0[0], a0[2], b0[0], b0[2] };
    const b1 = @Vector(4, u32){ a0[1], a0[3], b0[1], b0[3] };
    const c = a1 +% b1;
    return @bitCast(c);
}

// phaddw
pub inline fn _mm_hadd_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ phaddw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// phaddw
pub inline fn _mm_hadd_pi32(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ phaddd %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// phaddsw
pub inline fn _mm_hadds_epi16(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ phaddsw %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// phaddsw
pub inline fn _mm_hadds_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ phaddsw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// phsubw
pub inline fn _mm_hsub_epi16(a: __m128i, b: __m128i) __m128i {
    const a0: @Vector(8, u16) = @bitCast(a);
    const b0: @Vector(8, u16) = @bitCast(b);
    const a1 = @Vector(8, u16){ a0[0], a0[2], a0[4], a0[6], b0[0], b0[2], b0[4], b0[6] };
    const b1 = @Vector(8, u16){ a0[1], a0[3], a0[5], a0[7], b0[1], b0[3], b0[5], b0[7] };
    const c = a1 -% b1;
    return @bitCast(c);
}

// phsubd
pub inline fn _mm_hsub_epi32(a: __m128i, b: __m128i) __m128i {
    const a0: @Vector(4, u32) = @bitCast(a);
    const b0: @Vector(4, u32) = @bitCast(b);
    const a1 = @Vector(4, u32){ a0[0], a0[2], b0[0], b0[2] };
    const b1 = @Vector(4, u32){ a0[1], a0[3], b0[1], b0[3] };
    const c = a1 -% b1;
    return @bitCast(c);
}

// phsubw
pub inline fn _mm_hsub_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ phsubw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// phsubd
pub inline fn _mm_hsub_pi32(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ phsubd %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// phsubsw
pub inline fn _mm_hsubs_epi16(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ phsubsw %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// phsubsw
pub inline fn _mm_hsubs_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ phsubsw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// pmaddubsw
pub inline fn _mm_maddubs_epi16(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ pmaddubsw %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// pmaddubsw
pub inline fn _mm_maddubs_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ pmaddubsw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// pmulhrsw
pub inline fn _mm_mulhrs_epi16(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ pmulhrsw %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// pmulhrsw
pub inline fn _mm_mulhrs_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ pmulhrsw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// pshufb
pub inline fn _mm_shuffle_epi8(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ pshufb %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// pshufb
pub inline fn _mm_shuffle_pi8(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ pshufb %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// psignw
pub inline fn _mm_sign_epi16(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ psignw %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// psignd
pub inline fn _mm_sign_epi32(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ psignd %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// psignb
pub inline fn _mm_sign_epi8(a: __m128i, b: __m128i) __m128i {
    return asm volatile (
        \\ psignb %[b], %[a]
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// psignw
pub inline fn _mm_sign_pi16(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ psignw %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// psignd
pub inline fn _mm_sign_pi32(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ psignd %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

// psignb
pub inline fn _mm_sign_pi8(a: __m64, b: __m64) __m64 {
    return asm volatile (
        \\ psignb %[b], %[a]
        : [ret] "=y" (-> __m64),
        : [a] "0" (a),
          [b] "y" (b),
    );
}

const std = @import("std");
const testing = std.testing;

test "ssse3" {
    { // _mm_abs_epi16
        const a = @Vector(8, i16){ -1, -2, -3, -4, 1, 2, 3, 4 };
        const b = _mm_abs_epi16(@bitCast(a));
        const expected: __m128i = @bitCast(@Vector(8, i16){ 1, 2, 3, 4, 1, 2, 3, 4 });
        try testing.expectEqual(expected, b);
    }

    { // _mm_abs_epi32
        const a = @Vector(4, i32){ -1, -2, 1, 2 };
        const b = _mm_abs_epi32(@bitCast(a));
        const expected: __m128i = @bitCast(@Vector(4, i32){ 1, 2, 1, 2 });
        try testing.expectEqual(expected, b);
    }

    { // _mm_abs_epi8
        const a = @Vector(16, i8){ -1, -2, -3, -4, -5, -6, -7, -8, 1, 2, 3, 4, 5, 6, 7, 8 };
        const b = _mm_abs_epi8(@bitCast(a));
        const expected: __m128i = @bitCast(@Vector(16, i8){ 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8 });
        try testing.expectEqual(expected, b);
    }

    { // _mm_abs_pi16
        const a = @Vector(4, i16){ -1, -2, 1, 2 };
        const b = _mm_abs_pi16(@bitCast(a));
        const expected: __m64 = @bitCast(@Vector(4, i16){ 1, 2, 1, 2 });
        try testing.expectEqual(expected, b);
    }

    { // _mm_abs_pi32
        const a = @Vector(2, i32){ -1, 1 };
        const b = _mm_abs_pi32(@bitCast(a));
        const expected: __m64 = @bitCast(@Vector(2, i32){ 1, 1 });
        try testing.expectEqual(expected, b);
    }

    { // _mm_abs_pi8
        const a = @Vector(8, i8){ -1, -2, -3, -4, 1, 2, 3, 4 };
        const b = _mm_abs_pi8(@bitCast(a));
        const expected: __m64 = @bitCast(@Vector(8, i8){ 1, 2, 3, 4, 1, 2, 3, 4 });
        try testing.expectEqual(expected, b);
    }

    { // _mm_alignr_epi8
        const a: @Vector(16, u8) = "qrstuvwxyz012345".*;
        const b: @Vector(16, u8) = "abcdefghijklmnop".*;
        const c = _mm_alignr_epi8(@bitCast(a), @bitCast(b), 7);
        // |abcdefghijklmnop|qrstuvwxyz012345
        // =======> shift right by 7 bytes
        // abcdefg|hijklmnopqrstuvw|xyz012345
        const expected_c: @Vector(16, u8) = "hijklmnopqrstuvw".*;
        try testing.expectEqual(expected_c, @bitCast(c));
        const d = _mm_alignr_epi8(@bitCast(a), @bitCast(b), 18);
        // |abcdefghijklmnop|qrstuvwxyz012345
        // ==================> shift right by 18 bytes
        // abcdefghijklmnopqr|stuvwxyz012345..|
        const expected_d: @Vector(16, u8) = "stuvwxyz012345\x00\x00".*;
        try testing.expectEqual(expected_d, @bitCast(d));
    }

    { // _mm_alignr_pi8
        const a: @Vector(8, u8) = "ijklmnop".*;
        const b: @Vector(8, u8) = "abcdefgh".*;
        const c = _mm_alignr_pi8(@bitCast(a), @bitCast(b), 5);
        // |abcdefgh|ijklmnop
        // =====> shift right by 5 bytes
        // abcde|fghijklm|nop
        const expected_c: @Vector(8, u8) = "fghijklm".*;
        try testing.expectEqual(expected_c, @bitCast(c));
        const d = _mm_alignr_pi8(@bitCast(a), @bitCast(b), 10);
        // |abcdefgh|ijklmnop
        // ==========> shift right by 10 bytes
        // abcdefghij|klmnop..|
        const expected_d: @Vector(8, u8) = "klmnop\x00\x00".*;
        try testing.expectEqual(expected_d, @bitCast(d));
    }

    const i16_max: i16 = std.math.maxInt(i16);
    const i32_max: i32 = std.math.maxInt(i32);

    { // _mm_hadd_epi16
        const a = @Vector(8, i16){ 1, 2, 3, 4, 5, 6, 7, 8 };
        const b = @Vector(8, i16){ i16_max, 1, i16_max, 2, i16_max, 3, i16_max, 4 };
        const c = _mm_hadd_epi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(8, i16){
            1 + 2,        3 + 4,        5 + 6,        7 + 8,
            i16_max +% 1, i16_max +% 2, i16_max +% 3, i16_max +% 4,
        };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hadd_epi32
        const a = @Vector(4, i32){ 1, 2, 3, 4 };
        const b = @Vector(4, i32){ i32_max, 1, i32_max, 2 };
        const c = _mm_hadd_epi32(@bitCast(a), @bitCast(b));
        const expected = @Vector(4, i32){ 1 + 2, 3 + 4, i32_max +% 1, i32_max +% 2 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hadd_pi16
        const a = @Vector(4, i16){ 1, 2, 3, 4 };
        const b = @Vector(4, i16){ i16_max, 1, i16_max, 2 };
        const c = _mm_hadd_pi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(4, i16){ 1 + 2, 3 + 4, i16_max +% 1, i16_max +% 2 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hadd_pi32
        const a = @Vector(2, i32){ 1, 2 };
        const b = @Vector(2, i32){ i32_max, 1 };
        const c = _mm_hadd_pi32(@bitCast(a), @bitCast(b));
        const expected = @Vector(2, i32){ 1 + 2, i32_max +% 1 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hadds_epi16
        const a = @Vector(8, i16){ 1, 2, 3, 4, 5, 6, 7, 8 };
        const b = @Vector(8, i16){ i16_max, 1, i16_max, 2, i16_max, 3, i16_max, 4 };
        const c = _mm_hadds_epi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(8, i16){
            1 + 2,        3 + 4,        5 + 6,        7 + 8,
            i16_max +| 1, i16_max +| 2, i16_max +| 3, i16_max +| 4,
        };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hadds_pi16
        const a = @Vector(4, i16){ 1, 2, 3, 4 };
        const b = @Vector(4, i16){ i16_max, 1, i16_max, 2 };
        const c = _mm_hadds_pi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(4, i16){ 1 + 2, 3 + 4, i16_max +| 1, i16_max +| 2 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hsub_epi16
        const a = @Vector(8, i16){ 1, 2, 3, 4, 5, 6, 7, 8 };
        const b = @Vector(8, i16){ i16_max, 1, i16_max, 2, i16_max, 3, i16_max, 4 };
        const c = _mm_hsub_epi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(8, i16){
            1 - 2,        3 - 4,        5 - 6,        7 - 8,
            i16_max -% 1, i16_max -% 2, i16_max -% 3, i16_max -% 4,
        };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hsub_epi32
        const a = @Vector(4, i32){ 1, 2, 3, 4 };
        const b = @Vector(4, i32){ i32_max, 1, i32_max, 2 };
        const c = _mm_hsub_epi32(@bitCast(a), @bitCast(b));
        const expected = @Vector(4, i32){ 1 - 2, 3 - 4, i32_max -% 1, i32_max -% 2 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hsub_pi16
        const a = @Vector(4, i16){ 1, 2, 3, 4 };
        const b = @Vector(4, i16){ i16_max, 1, i16_max, 2 };
        const c = _mm_hsub_pi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(4, i16){ 1 - 2, 3 - 4, i16_max -% 1, i16_max -% 2 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hsub_pi32
        const a = @Vector(2, i32){ 1, 2 };
        const b = @Vector(2, i32){ i32_max, 1 };
        const c = _mm_hsub_pi32(@bitCast(a), @bitCast(b));
        const expected = @Vector(2, i32){ 1 - 2, i32_max -% 1 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hsubs_epi16
        const a = @Vector(8, i16){ 1, 2, 3, 4, 5, 6, 7, 8 };
        const b = @Vector(8, i16){ i16_max, 1, i16_max, 2, i16_max, 3, i16_max, 4 };
        const c = _mm_hsubs_epi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(8, i16){
            1 - 2,        3 - 4,        5 - 6,        7 - 8,
            i16_max -| 1, i16_max -| 2, i16_max -| 3, i16_max -| 4,
        };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_hsubs_pi16
        const a = @Vector(4, i16){ 1, 2, 3, 4 };
        const b = @Vector(4, i16){ i16_max, 1, i16_max, 2 };
        const c = _mm_hsubs_pi16(@bitCast(a), @bitCast(b));
        const expected = @Vector(4, i16){ 1 - 2, 3 - 4, i16_max -| 1, i16_max -| 2 };
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_maddubs_epi16
        const a = [16]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 250, 251, 252, 253, 254, 255 };
        const b = [16]i8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, -123, -124, -125, -126, -127, -128 };
        const c = _mm_maddubs_epi16(@bitCast(a), @bitCast(b));
        var expected: [8]i16 = undefined;
        for (0..8) |i| {
            const v0 = @as(i16, a[i * 2]) * @as(i16, b[i * 2]);
            const v1 = @as(i16, a[i * 2 + 1]) * @as(i16, b[i * 2 + 1]);
            expected[i] = v0 +| v1;
        }
        try testing.expectEqual(expected, @bitCast(c));
    }

    { // _mm_maddubs_pi16
        const a = [8]u8{ 1, 2, 3, 4, 250, 251, 252, 253 };
        const b = [8]i8{ 1, 2, 3, 4, -123, -124, -125, -126 };
        const c = _mm_maddubs_pi16(@bitCast(a), @bitCast(b));
        var expected: [4]i16 = undefined;
        for (0..4) |i| {
            const v0 = @as(i16, a[i * 2]) * @as(i16, b[i * 2]);
            const v1 = @as(i16, a[i * 2 + 1]) * @as(i16, b[i * 2 + 1]);
            expected[i] = v0 +| v1;
        }
        try testing.expectEqual(expected, @bitCast(c));
    }
}
