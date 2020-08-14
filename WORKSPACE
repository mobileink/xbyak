# load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

# http_archive(
#     name = "rules_cc",
#     sha256 = "e75dfb05bc1e89ebbb6696cadb5e455833690009310d9dc5512151c5adb0e4e3",
#     strip_prefix = "rules_cc-cfe68f6bc79dea602f2f6a767797f94a5904997f",
#     urls = ["https://github.com/bazelbuild/rules_cc/archive/cfe68f6bc79dea602f2f6a767797f94a5904997f.zip"],
# )


## rules_foreign_cc: the order is important - first fetch the archive,
## then load the rules.
# http_archive(
#     name = "rules_foreign_cc",
#     strip_prefix="rules_foreign_cc-master",
#     url = "https://github.com/bazelbuild/rules_foreign_cc/archive/master.zip",
# )

# load("@rules_foreign_cc//:workspace_definitions.bzl", "rules_foreign_cc_dependencies")

# rules_foreign_cc_dependencies()

################
## boost is needed by //sample:calc

git_repository(
    name = "com_github_nelhage_rules_boost",
    commit = "9f9fb8b2f0213989247c9d5c0e814a8451d18d7f",
    remote = "https://github.com/nelhage/rules_boost",
    shallow_since = "1570056263 -0700",
)

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()

################################################################
## cross-compile

# http_archive(
#     name = "bazel_skylib",
#     url = "https://github.com/bazelbuild/bazel-skylib/archive/b113ed5d05ccddee3093bb157b9b02ab963c1c32.zip",
#     sha256 = "cea47b31962206b7ebf2088f749243868d5d9305273205bdd8651567d3e027fc",
#     strip_prefix = "bazel-skylib-b113ed5d05ccddee3093bb157b9b02ab963c1c32",
# )
# load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
# bazel_skylib_workspace()

# replace with your toolchain root
# see https://crosstool-ng.github.io/
# this is for macos, which needs a case-sensitive filesystem (dmg)
TC_ROOT = "/Volumes/CrossToolNG/x86_64-unknown-linux-gnu"

# new_local_repository(
#     name = "ctng",
#     path = TC_ROOT,
#     build_file = 'bzl/tc/ctng_tc.BUILD',
# )

# new_local_repository(
#     name = "musl",
#     path = TC_ROOT,
#     build_file = 'bzl/tc/musl_tc.BUILD',
# )

# register_toolchains(
#     "//bzl/tc:all",
#     # Target patterns are also permitted, so we could have also written:
#     # "//bar_tools:all",
# )

# Tell Bazel that //:linux_platform is allowed execution platform - that our
# host system or remote execution service can handle that platform.
# register_execution_platforms("//:mac_platform")
