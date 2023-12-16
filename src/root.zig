const x86 = struct {
    pub const common = @import("x86/common.zig");
    pub const sse2 = @import("x86/sse2.zig");
    pub const sse3 = @import("x86/sse3.zig");
    pub const sse4_1 = @import("x86/sse4.1.zig");
    pub const sse4_2 = @import("x86/sse4.2.zig");
    pub const ssse3 = @import("x86/ssse3.zig");

    pub const __m128d = common.__m128d;
    pub const __m128i = common.__m128i;
    pub const __m128 = common.__m128;

    pub const __m64 = common.__m64;
    pub const __v1di = common.__v1di;
    pub const __v2si = common.__v2si;
    pub const __v4hi = common.__v4hi;
    pub const __v8qi = common.__v8qi;

    pub const _mm_shuffle = common._mm_shuffle;

    pub usingnamespace sse2;
    pub usingnamespace sse3;
    pub usingnamespace sse4_1;
    pub usingnamespace sse4_2;
    pub usingnamespace ssse3;
};

pub usingnamespace x86;

comptime {
    @import("std").testing.refAllDeclsRecursive(x86);
}
