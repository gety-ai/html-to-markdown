const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const test_step = b.step("test", "Run tests");

    // Select the platform-specific dependency based on build host.
    const pkg_name = if (builtin.target.os.tag == .linux) (
        if (builtin.target.cpu.arch == .x86_64) "html_to_markdown_linux_x86_64" else "html_to_markdown_linux_aarch64")
    else if (builtin.target.os.tag == .macos) (
        if (builtin.target.cpu.arch == .x86_64) "html_to_markdown_macos_amd64" else "html_to_markdown_macos_arm64")
    else if (builtin.target.os.tag == .windows) "html_to_markdown_windows_x64" else @compileError("unsupported platform for this Zig package");

    const html_to_markdown_rs_module = b.dependency(pkg_name, .{
        .target = target,
        .optimize = optimize,
    }).module("html_to_markdown_rs");

    const conversion_module = b.createModule(.{
        .root_source_file = b.path("src/conversion_test.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    conversion_module.addImport("html_to_markdown_rs", html_to_markdown_rs_module);
    const conversion_tests = b.addTest(.{
        .name = "conversion_test",
        .root_module = conversion_module,
        .use_llvm = true,
    });
    const conversion_run = b.addRunArtifact(conversion_tests);
    test_step.dependOn(&conversion_run.step);

    const smoke_module = b.createModule(.{
        .root_source_file = b.path("src/smoke_test.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    smoke_module.addImport("html_to_markdown_rs", html_to_markdown_rs_module);
    const smoke_tests = b.addTest(.{
        .name = "smoke_test",
        .root_module = smoke_module,
        .use_llvm = true,
    });
    const smoke_run = b.addRunArtifact(smoke_tests);
    test_step.dependOn(&smoke_run.step);

}
