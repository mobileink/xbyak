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

## cmd line build settings
def musl_home_impl(ctx):
    _home = ctx.build_setting_value
    return HomeProvider(home = _home)

musl_home = rule(
    implementation = musl_home_impl,
    build_setting = config.string(flag = True)
)

def musl_triplet_impl(ctx):
    _triplet = ctx.build_setting_value
    return TripletProvider(triplet = _triplet)

musl_triplet = rule(
    implementation = musl_triplet_impl,
    build_setting = config.string(flag = True)
)

## toolchain defn
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
                        "-no-canonical-prefixes",
                        "-L/usr/local/Cellar/musl-cross/0.9.9/libexec/libexec/gcc/x86_64-linux-musl/9.2.0",
                        "-Lmusl-cross/0.9.9/libexec/libexec/gcc/x86_64-linux-musl/9.2.0",
                        "-Llibexec/libexec/gcc/x86_64-linux-musl/9.2.0",
                        "-Llibexec/gcc/x86_64-linux-musl/9.2.0",
                        "-Lgcc/x86_64-linux-musl/9.2.0",
                        "-Lx86_64-linux-musl/9.2.0",
                        "-L9.2.0",
                        "-llto_plugin",
                        # "-pass-exit-codes",
                        # "--target=x86_64-unknown-linux-gnu",
                        # "-mcpu=x86_64",
                    ],
                ),
            ],
        ),
        flag_set(
            actions = all_link_actions,
            flag_groups = [flag_group(flags = ["-Wl,--gc-sections", "-v"])],
            # with_features = [with_feature_set(features = ["opt"])],
        ),
    ],
)

def musl_tc_config_impl(ctx):
    triplet = ctx.attr.musl_triplet[TripletProvider].triplet
    musl_root   = ctx.attr.musl_home[HomeProvider].home
    musl_sysroot = musl_root + "/libexec/" + triplet
    tool_prefix = "/usr/local/bin/" + triplet + "-"
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
        toolchain_identifier = "musl-toolchain",
        host_system_name = "macos",
        target_system_name = triplet,
        target_cpu = "x86_64",
        target_libc = "unknown",
        compiler = "gcc",
        builtin_sysroot = musl_sysroot,
        cxx_builtin_include_directories = [
            "%sysroot%/include",
            musl_root + "/include/c++",
            # musl_root + "/lib/gcc/" + triplet + "/6.3.0/include",
            # musl_root + "/lib/gcc/" + triplet + "/6.3.0/include-fixed"
        ],
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
        features = [
            default_link_flags_feature,
            # link_libcpp_feature
        ]
    )

musl_toolchain_config = rule(
    implementation = musl_tc_config_impl,
    # toolchains = [
    #     "@rules_cc//cc:toolchain_type", # copybara-use-repo-external-label
    # ],
    attrs = {
        "musl_home": attr.label(mandatory = True),
        "musl_triplet": attr.label(mandatory = True),
    },
    provides = [CcToolchainConfigInfo],
)
