const std = @import("std");
const builtin = @import("builtin");

// const min_ver = "0.15.0";

// comptime {
//     const order = std.SemanticVersion.order;
//     const parse = std.SemanticVersion.parse;
//     if (order(builtin.zig_version, parse(min_ver) catch unreachable) == .lt)
//         @compileError("SDL_image requires zig version " ++ min_ver);
// }

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const sdl_dep = b.dependency("sdl", .{
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(sdl_dep.artifact("SDL3"));

    const sdl_image_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    sdl_image_mod.addCMacro("BUILD_SDL", "1");
    sdl_image_mod.addCMacro("DLL_EXPORT", "1");
    sdl_image_mod.addCMacro("LOAD_BMP", "1");
    sdl_image_mod.addCMacro("LOAD_GIF", "1");
    sdl_image_mod.addCMacro("LOAD_JPG", "1");
    sdl_image_mod.addCMacro("LOAD_LBM", "1");
    sdl_image_mod.addCMacro("LOAD_PCX", "1");
    sdl_image_mod.addCMacro("LOAD_PNG", "1");
    sdl_image_mod.addCMacro("LOAD_PNM", "1");
    sdl_image_mod.addCMacro("LOAD_QOI", "1");
    sdl_image_mod.addCMacro("LOAD_SVG", "1");
    sdl_image_mod.addCMacro("LOAD_TGA", "1");
    sdl_image_mod.addCMacro("LOAD_XCF", "1");
    sdl_image_mod.addCMacro("LOAD_XPM", "1");
    sdl_image_mod.addCMacro("LOAD_XV", "1");
    sdl_image_mod.addCMacro("SDL_BUILD_MAJOR_VERSION", "3");
    sdl_image_mod.addCMacro("SDL_BUILD_MICRO_VERSION", "4");
    sdl_image_mod.addCMacro("SDL_BUILD_MINOR_VERSION", "2");
    sdl_image_mod.addCMacro("SDL_IMAGE_SAVE_JPG", "1");
    sdl_image_mod.addCMacro("SDL_IMAGE_SAVE_PNG", "1");
    sdl_image_mod.addCMacro("USE_STBIMAGE", "1");

    const sdl_image_lib = b.addLibrary(.{
        .name = "sdl_image",
        .root_module = sdl_image_mod,
    });

    sdl_image_lib.addCSourceFiles(.{
        .files = &.{
            "src/IMG.c",
            "src/IMG_WIC.c",
            "src/IMG_avif.c",
            "src/IMG_bmp.c",
            "src/IMG_gif.c",
            "src/IMG_jpg.c",
            "src/IMG_jxl.c",
            "src/IMG_lbm.c",
            "src/IMG_pcx.c",
            "src/IMG_png.c",
            "src/IMG_pnm.c",
            "src/IMG_qoi.c",
            "src/IMG_stb.c",
            "src/IMG_svg.c",
            "src/IMG_tga.c",
            "src/IMG_tif.c",
            "src/IMG_webp.c",
            "src/IMG_xcf.c",
            "src/IMG_xpm.c",
            "src/IMG_xv.c",
            "src/IMG_ImageIO.m",
        },
        .flags = &.{
            "-Wall",
            "-Wundef",
            "-Wfloat-conversion",
            "-fno-strict-aliasing",
            "-Wshadow",
            "-Wno-unused-local-typedefs",
            "-Wimplicit-fallthrough",
        },
    });

    sdl_image_lib.addIncludePath(b.path("include/"));
    //sdl_image_lib.addIncludePath(b.path("src/"));
    sdl_image_lib.addSystemIncludePath(b.path("SDL3/"));

    sdl_image_lib.linkLibrary(sdl_dep.artifact("SDL3"));
    sdl_image_lib.installHeader(b.path("include/SDL3_image/SDL_image.h"), "SDL3_image/SDL_image.h");
    b.installArtifact(sdl_image_lib);
}
