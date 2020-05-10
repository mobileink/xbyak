load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
     "tool_path",
     "feature",
     #"feature_set",
     "with_feature_set",
     "flag_set",
     "flag_group"
)

load("@bazel_tools//tools/cpp:cc_toolchain_config.bzl",
     "all_link_actions"
)

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

# def _ctng_toolchain_impl(ctx):
#     toolchain_info = platform_common.ToolchainInfo(
#         targetting_cpu = ctx.attr.targetting_cpu,
#         targetting_os = ctx.attr.targetting_os,
#         executing_on_cpu = ctx.attr.executing_on_cpu,
#         executing_on_os = ctx.attr.executing_on_os,
#     )
#     return [toolchain_info]

# ctng_toolchain = rule(
#     implementation = _ctng_toolchain_impl,
#     attrs = {
#         "targetting_cpu": attr.string(mandatory = True),
#         "targetting_os": attr.string(mandatory = True),
#         "executing_on_cpu": attr.string(mandatory = True),
#         "executing_on_os": attr.string(mandatory = True),
#     },
# )

# all_link_actions = [
#     ACTION_NAMES.cpp_link_executable,
#     # ACTION_NAMES.cpp_link_dynamic_library,
#     # ACTION_NAMES.cpp_link_nodeps_dynamic_library,
# ]

# link_libcpp_feature = feature(
#     name = "link_libc++",
#     enabled = True,
#     flag_sets = [
#         flag_set(
#             # actions = all_link_actions +
#             ["objc-executable", "objc++-executable"],
#             flag_groups = [flag_group(flags = ["-lstdc++"])],
#             with_features = [with_feature_set(not_features = ["kernel_extension"])],
#         ),
#     ],
# )

default_link_flags_feature = feature(
    name = "default_link_flags",
    enabled = True,
    flag_sets = [
        flag_set(
            actions = all_link_actions,
            flag_groups = [
                flag_group(
                    flags = [
                        "-v",
                        "-lstdc++",
                        "-lm", # fixes: undefined reference to symbol 'pow@@GLIBC_2.2.5'
                        # "-Wl,-z,relro,-z,now",
                        "-no-canonical-prefixes",
                        # "-pass-exit-codes",
                        # "--target=x86_64-unknown-linux-gnu",
                        # "-mcpu=x86_64",
                    ],
                ),
            ],
        ),
        flag_set(
            actions = all_link_actions,
            flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
            with_features = [with_feature_set(features = ["opt"])],
        ),
    ],
)

# triplet = "armv8-rpi3-linux-gnueabihf"
# ctng_root   = "/Volumes/CrossToolNG/armv8-rpi3-linux-gnueabihf"
# tool_prefix = ctng_root + "/bin/armv8-rpi3-linux-gnueabihf-"

# triplet = "x86_64-unknown-linux-gnu"
# ctng_root   = "/Volumes/CrossToolNG/" + triplet
# tool_prefix = ctng_root + "/bin/" + triplet + "-"

def ctng_tc_config_impl(ctx):
    triplet = ctx.attr.ctng_triplet[TripletProvider].triplet
    ctng_root   = ctx.attr.ctng_home[HomeProvider].home + "/" + triplet
    ctng_sysroot = ctng_root + "/" + triplet + "/sysroot"
    tool_prefix = ctng_root + "/bin/" + triplet + "-"
    tool_paths = [
        tool_path( name = "gcc",      path = tool_prefix + "gcc" ),
        tool_path( name = "ld",       path = tool_prefix + "ld" ),
        tool_path( name = "ar",       path = tool_prefix + "ar" ),
        tool_path( name = "cpp",      path = tool_prefix + "cpp" ),
        tool_path( name = "gcov",     path = tool_prefix + "gcov" ),
        tool_path( name = "nm",       path = tool_prefix + "nm" ),
        tool_path( name = "objdump",  path = tool_prefix + "objdump" ),
        tool_path( name = "strip",    path = tool_prefix + "strip" ),
    ]
    return cc_common.create_cc_toolchain_config_info(
    # return platform_common.ToolchainInfo(
        ctx = ctx,
        toolchain_identifier = triplet + "-toolchain",
        host_system_name = "macos",
        target_system_name = triplet,
        target_cpu = "fixme",
        target_libc = "unknown",
        compiler = "gcc",
        builtin_sysroot = ctng_sysroot,
        cxx_builtin_include_directories = [
            "%sysroot%/usr/include",
            ctng_root + "/" + triplet + "/include/c++/6.3.0",
            ctng_root + "/lib/gcc/" + triplet + "/6.3.0/include",
            ctng_root + "/lib/gcc/" + triplet + "/6.3.0/include-fixed"
        ],
        # "lib/gcc/x86_64-unknown-linux-gnu/6.3.0/include",
        # "lib/gcc/x86_64-unknown-linux-gnu/6.3.0/include-fixed",
        # "x86_64-unknown-linux-gnu/include"],
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
        features = [
            default_link_flags_feature,
            # link_libcpp_feature
        ]
    )

ctng_toolchain_config = rule(
    implementation = ctng_tc_config_impl,
    # toolchains = [
    #     "@rules_cc//cc:toolchain_type", # copybara-use-repo-external-label
    # ],
    attrs = {
        "ctng_home": attr.label(mandatory = True),
        "ctng_triplet": attr.label(mandatory = True),
    },
    provides = [CcToolchainConfigInfo],
)
