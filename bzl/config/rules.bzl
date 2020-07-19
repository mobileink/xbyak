# rules.bzl

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
## Intel
# i386 = IA-32 = 80386 32-bit version of x86 instruction set architecture
# i486 - 80486
# i586 - P5, Pentium
# i686 - P6, Pentium Pro
# Core, Core2
# IA-64 - Itanium

## ARM
# thumb - 16 bit ISA
# thumb2 - 32 bit ISA
# ARM ISA
# e.g., Cortex-A8 programmer's model:
# The processor implements ARMv7-A. This includes:
# * the 32-bit ARM instruction set
# * the 16-bit and 32-bit Thumb-2 instruction set
# * the Thumb-2EE instruction set
# * the TrustZone technology
# * the NEON technology.

# Neon, VFP
# armv7
# armv8
## aarch64 is the 64-bit execution state of the ARMv8 ISA. A machine
## in this state executes operates on the A64 instruction set. This is
## in contrast to the AArch32 which describes the classical 32-bit ARM
## execution state.

# aarch64 = arm64

# sub = for ex. on ARM: v5, v6m, v7a, v7m, etc.
# vendor = pc, apple, nvidia, ibm, etc.
# sys = none, linux, win32, darwin, cuda, etc.
# abi = eabi, gnu, android, macho, elf, etc.

ArchProvider = provider(fields = ['arch'])
architectures = ["x86_64", "i386", "arm", "thumb", "mips"]

SubArchProvider = provider(fields = ['subarch'])
subarchitectures = {"arm": ["v5", "v6m", "v7a", "v7m"]}

VendorProvider = provider(fields = ['vendor'])
vendors = ["pc", "apple", "unknown"]

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

HomeProvider = provider(fields = ["home"])
TripletProvider = provider(fields = ["triplet"])

def ctng_home_impl(ctx):
    _home = ctx.build_setting_value
    return HomeProvider(home = _home)

ctng_home = rule(
    implementation = ctng_home_impl,
    build_setting = config.string(flag = True)
)

def ctng_triplet_impl(ctx):
    _triplet = ctx.build_setting_value
    return TripletProvider(triplet = _triplet)

ctng_triplet = rule(
    implementation = ctng_triplet_impl,
    build_setting = config.string(flag = True)
)
