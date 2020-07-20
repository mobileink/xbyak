# toolchain.bzl

# platform v. config
# "platform" means base config for triplet
# "config" adds refinements

# e.g. for a given platform we might configure multiple builds
# involving various optimization levels, SSP support, etc. These are
# platform variants, not distinct platforms.  Put differently, these
# are platform-independent parameters.  So for a given build we must
# select a target and also a configuration; the latter will be mostly
# platform-independent, but some platforms may have unique config
# options.

## platform definitions

## gnu triples: cpu-vendor-os, where os can be system or kernel-system.
# the list from libtool:
# https://git.savannah.gnu.org/cgit/libtool.git/tree/doc/PLATFORMS
# e.g.
# i686-pc-linux-gnu
# arm-none-linux-gnueabi

## clang triples:
# The triple has the general format
#   <arch><sub>-<vendor>-<sys>-<abi>
# list at: https://llvm.org/doxygen/classllvm_1_1Triple.html
# commented at: https://llvm.org/doxygen/Triple_8h_source.html#l00078
# arch = x86_64, i386, arm, thumb, mips, etc.
# sub = for ex. on ARM: v5, v6m, v7a, v7m, etc.
# vendor = pc, apple, nvidia, ibm, etc.
# sys = none, linux, win32, darwin, cuda, etc.
# abi = eabi, gnu, android, macho, elf, etc.

# crosstool-ng uses ARCH, VENDOR, KERNEL and SYS.  SYS means abi, or
# clib.

# examples:
# aarch64-rpi3-linux-gnu
# arm-unknown-linux-musleabi
# armv7-rpi2-linux-gnueabihf
# avr
# x86_64-multilib-linux-musl
# x86_64-ubuntu16.04-linux-gnu
# x86_64-unknown-linux-gnu
# x86_64-w64-mingw32

## toolchains.bootlin.com
# https://toolchains.bootlin.com/toolchains.html


ArchProvider = provider(fields = ['arch'])
architectures = ["x86_64", "i386", "arm", "thumb", "mips"]

SubArchProvider = provider(fields = ['subarch'])
subarchitectures = {"arm": ["v5", "v6m", "v7a", "v7m"]}

VendorProvider = provider(fields = ['vendor'])
vendors = ["pc", "apple", "unknown"]

# one build rule per provider

def arch_impl(ctx):
    raw_arch = ctx.build_setting_value
    if raw_arch not in architectures:
        fail(str(ctx.label) + " build setting allowed to take values {"
             + ", ".join(architectures) + "} but was set to unallowed value "
             + raw_arch)
    return ArchProvider(type = raw_arch)

arch = rule(
    implementation = arch_impl,
    build_setting = config.string(flag = True)
    # NB: no attrib, no default?
)

## now:  bazel build //foo:bar --//toolchain:arch=arm


## platform: conjunction of build properties (rules)
# set in BUILD files?

# namespacing - by defining these things in the appropriate packages
# we get good names.  E.g. architectures should be defined in
# //arch/BUILD, so we can write //arch:x86_64
# //clib/BUILD yields //clib:gnu, //clib:ulibc, //clib:musl, etc.
# ideally the clib/abi would be in platforms, giving e.g.
#  @platforms//abi:musl, @platforms//abi:gnu,
#  @platforms//abi:glibc, @platforms//abi:uClib-ng,
#  @platforms//abi:newlib,
#  @platforms//abi:eabi, etc.

constraint_setting(name = "glibc_version")
constraint_value(constraint_setting = ":glibc_version",
                 name = "glibc_2_25")
constraint_value(constraint_setting = ":glibc_version",
                 name = "glibc_2_26")

# platform(
#     name = "linux_x86",
#     constraint_values = [
#         "@platforms//os:linux",
#         "@platforms//cpu:x86_64",
#         ":glibc_2_25",
#     ],
# )
