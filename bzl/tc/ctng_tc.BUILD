# MAC CAVEAT: if you do not mount the ctng dmg, you'll get an error
# something like:
# ERROR: /Users/gar/snark/xbyak/bzl/tc/BUILD:52:1: //bzl/tc:_mac_to_linux_toolchain depends on @ctng//:all in repository @ctng which failed to fetch. no such package '@ctng//': The repository's path is "/Volumes/CrossToolNG/x86_64-unknown-linux-gnu" (absolute: "/Volumes/CrossToolNG/x86_64-unknown-linux-gnu") but this directory does not exist.

# the toolchain BUILD package defines the filegroups used by CROSSTOOL

package(default_visibility = ["//visibility:public"])

TARGET = "x86_64-unknown-linux-gnu"

filegroup(
    name = "sysroot",
    srcs = [
        TARGET + "/sysroot"
    ],
)

filegroup(
    name = "all",
    srcs = glob(["**"])
)

filegroup(
    name = "compiler",
    srcs = ["bin/" + TARGET + "-gcc",
            "bin/" + TARGET + "-as",
            "bin/" + TARGET + "-ld"],
)

filegroup(
    name = "linker",
    srcs = ["bin/" + TARGET + "-gcc",
            "bin/" + TARGET + "-ar",
            "bin/" + TARGET + "-ld"],
)

# filegroup(
#     name = "headers",
#     srcs = glob(
#         [
#             "include/**/*h",
#             "lib/gcc/" + TARGET + "/6.3.0/include/**/*.h",
#             "lib/gcc/" + TARGET + "/6.3.0/include-fixed/**/*.h",
#             TARGET + "/" + TARGET + "/include/**/*.h",
#             TARGET + "/sysroot/include/**/*.h",
#             TARGET + "/sysroot/usr/include/*.h",
#             TARGET + "/sysroot/usr/include/*.h",
#             TARGET + "/include/c++/**/*h",
#             TARGET + "/lib/gcc/" + TARGET + "/6.3.0/include/stddef.h"]
#         ,
#     ),
# )

