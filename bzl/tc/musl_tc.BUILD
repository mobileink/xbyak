# the toolchain BUILD package defines the filegroups used by CROSSTOOL

package(default_visibility = ["//visibility:public"])

TARGET = "x86_64-linux-musl"

# filegroup(
#     name = "sysroot",
#     srcs = [
#         TARGET + "/sysroot"
#     ],
# )

filegroup(
    name = "all",
    srcs = glob(["**/*"])
)

filegroup(
    name = "compiler",
    srcs = glob(["x86_64-linux-musl-*"])
    # + ":headers"
)

filegroup(
    name = "linker",
    srcs = ["bin/" + TARGET + "-gcc",
            "bin/" + TARGET + "-ar",
            "bin/" + TARGET + "-ld"],
)

filegroup(
    name = "headers",
    srcs = glob(
        [
            "**/*.h"
        ]
    ),
)

