const common = @import("common.zig");
const comptimePrint = @import("std").fmt.comptimePrint;
const __m128i = common.__m128i;

pub const SIDD = struct {
    /// unsigned 8-bit characters
    const UBYTE_OPS = 0;
    /// unsigned 16-bit characters
    const UWORD_OPS = 1;
    /// signed 8-bit characters
    const SBYTE_OPS = 2;
    /// signed 16-bit characters
    const SWORD_OPS = 3;
    /// compare equal any
    const CMP_EQUAL_ANY = 0;
    /// compare ranges
    const CMP_RANGES = 4;
    /// compare equal each
    const CMP_EQUAL_EACH = 8;
    /// compare equal ordered
    const CMP_EQUAL_ORDERED = 12;
    /// negate results
    const NEGATIVE_POLARITY = 16;
    /// negate results only before end of string
    const MASKED_NEGATIVE_POLARITY = 48;
    /// index only: return last significant bit
    const LEAST_SIGNIFICANT = 0;
    /// index only: return most significant bit
    const MOST_SIGNIFICANT = 64;
    /// mask only: return bit mask
    const BIT_MASK = 0;
    /// mask only: return byte/word mask
    const UNIT_MASK = 64;
};

// pcmpestri
pub inline fn _mm_cmpestra(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %esi, %esi
            \\ pcmpestri ${d}, %[b], %[a]
            \\ seta %sil
        , .{imm8})
        : [ret] "={esi}" (-> bool),
        : [a] "x" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
        : "cc"
    );
}

// pcmpestri
pub inline fn _mm_cmpestrc(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %esi, %esi
            \\ pcmpestri ${d}, %[b], %[a]
            \\ setb %sil
        , .{imm8})
        : [ret] "={esi}" (-> bool),
        : [a] "x" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
        : "cc"
    );
}

// pcmpestri
pub inline fn _mm_cmpestri(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) u32 {
    return asm volatile (comptimePrint("pcmpestri ${d}, %[b], %[a]", .{imm8})
        : [ret] "={ecx}" (-> u32),
        : [a] "x" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
        : "cc"
    );
}

// pcmpestrm
pub inline fn _mm_cmpestrm(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) __m128i {
    return asm volatile (comptimePrint("pcmpestrm ${d}, %[b], %[a]", .{imm8})
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
    );
}

// pcmpestri
pub inline fn _mm_cmpestro(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %esi, %esi
            \\ pcmpestri ${d}, %[b], %[a]
            \\ seto %sil
        , .{imm8})
        : [ret] "={esi}" (-> bool),
        : [a] "x" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
        : "cc"
    );
}

// pcmpestri
pub inline fn _mm_cmpestrs(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %esi, %esi
            \\ pcmpestri ${d}, %[b], %[a]
            \\ sets %sil
        , .{imm8})
        : [ret] "={esi}" (-> bool),
        : [a] "x" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
        : "cc"
    );
}

// pcmpestri
pub inline fn _mm_cmpestrz(a: __m128i, la: u32, b: __m128i, lb: u32, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %esi, %esi
            \\ pcmpestri ${d}, %[b], %[a]
            \\ sete %sil
        , .{imm8})
        : [ret] "={esi}" (-> bool),
        : [a] "x" (a),
          [la] "{eax}" (la),
          [b] "x" (b),
          [lb] "{edx}" (lb),
        : "cc"
    );
}

// pcmpgtq
pub inline fn _mm_cmpgt_epi64(a: __m128i, b: __m128i) __m128i {
    const all_0: __m128i = @splat(0);
    const all_ff: __m128i = @splat(-1);
    return @select(i64, a > b, all_ff, all_0);
}

// pcmpistri
pub inline fn _mm_cmpistra(a: __m128i, b: __m128i, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %eax, %eax
            \\ pcmpistri ${d}, %[b], %[a]
            \\ seta %al
        , .{imm8})
        : [ret] "={eax}" (-> bool),
        : [a] "x" (a),
          [b] "x" (b),
        : "cc"
    );
}
// pcmpistri
pub inline fn _mm_cmpistrc(a: __m128i, b: __m128i, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %eax, %eax
            \\ pcmpistri ${d}, %[b], %[a]
            \\ setb %al
        , .{imm8})
        : [ret] "={eax}" (-> bool),
        : [a] "x" (a),
          [b] "x" (b),
        : "cc"
    );
}
// pcmpistri
pub inline fn _mm_cmpistri(a: __m128i, b: __m128i, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ pcmpistri ${d}, %[b], %[a]
        , .{imm8})
        : [ret] "={ecx}" (-> u32),
        : [a] "x" (a),
          [b] "x" (b),
    );
}

// pcmpistrm
pub inline fn _mm_cmpistrm(a: __m128i, b: __m128i, comptime imm8: u8) __m128i {
    return asm volatile (comptimePrint(
            \\ pcmpistrm ${d}, %[b], %[a]
        , .{imm8})
        : [ret] "=x" (-> __m128i),
        : [a] "0" (a),
          [b] "x" (b),
    );
}

// pcmpistri
pub inline fn _mm_cmpistro(a: __m128i, b: __m128i, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %eax, %eax
            \\ pcmpistri ${d}, %[b], %[a]
            \\ seto %al
        , .{imm8})
        : [ret] "={eax}" (-> bool),
        : [a] "x" (a),
          [b] "x" (b),
        : "cc"
    );
}

// pcmpistri
pub inline fn _mm_cmpistrs(a: __m128i, b: __m128i, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %eax, %eax
            \\ pcmpistri ${d}, %[b], %[a]
            \\ sets %al
        , .{imm8})
        : [ret] "={eax}" (-> bool),
        : [a] "x" (a),
          [b] "x" (b),
        : "cc"
    );
}

// pcmpistri
pub inline fn _mm_cmpistrz(a: __m128i, b: __m128i, comptime imm8: u8) bool {
    return asm volatile (comptimePrint(
            \\ xor %eax, %eax
            \\ pcmpistri ${d}, %[b], %[a]
            \\ sete %al
        , .{imm8})
        : [ret] "={eax}" (-> bool),
        : [a] "x" (a),
          [b] "x" (b),
        : "cc"
    );
}

// crc32
pub inline fn _mm_crc32_u16(crc: u32, v: u16) u32 {
    return asm volatile (
        \\ crc32 %[b], %[a]
        : [ret] "=r" (-> u32),
        : [a] "0" (crc),
          [b] "r" (v),
    );
}

// crc32
pub inline fn _mm_crc32_u32(crc: u32, v: u32) u32 {
    return asm volatile (
        \\ crc32 %[b], %[a]
        : [ret] "=r" (-> u32),
        : [a] "0" (crc),
          [b] "r" (v),
    );
}

// crc32
pub inline fn _mm_crc32_u64(crc: u64, v: u64) u64 {
    return asm volatile (
        \\ crc32 %[b], %[a]
        : [ret] "=r" (-> u64),
        : [a] "0" (crc),
          [b] "r" (v),
    );
}

// crc32
pub inline fn _mm_crc32_u8(crc: u32, v: u8) u32 {
    return asm volatile (
        \\ crc32 %[b], %[a]
        : [ret] "=r" (-> u32),
        : [a] "0" (crc),
          [b] "r" (v),
    );
}
