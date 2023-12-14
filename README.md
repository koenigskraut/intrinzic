# intrinzic

A collection of x86 intrinsics ported to Zig. Usage is strongly discouraged. Primary purpose is having an ability to port C code that uses intrinsics directly without inline assembly on user side. Inline assembly was used as little as possible, only where it wasn't possible to reproduce the required behavior without it. 

**NB**: Consider specifying target with as small feature set as possible, since Zig code provides no guarantee, what instructions it will be lowered to and __will__ use more advanced (and possibly unwanted) instructions if it can do so.

