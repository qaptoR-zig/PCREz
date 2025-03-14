const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // PCRE2 Regex Library
    const pcre2_8_dep = b.dependency("pcre2", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.addModule("pcrez", .{
        .root_source_file = b.path("src/regex.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_mod.linkLibrary(pcre2_8_dep.artifact("pcre2-8"));

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    lib_unit_tests.linkLibrary(pcre2_8_dep.artifact("pcre2-8"));

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
