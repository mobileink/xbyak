## usage: load("//config:variables.bzl", "DEFINES", "OS_COPTS")

# this uses the legacy technique of using --define foo=bar to set a
# config_setting (in config/BUILD) which is selected here (as
# "//config:foo": "bar")

# todo: convert to use starlark config flags (build_setting)
# https://docs.bazel.build/versions/master/skylark/config.html

# skylib contains common build settings, ie. bool_flag, string_flag, etc.
# https://github.com/bazelbuild/bazel-skylib

load("@bazel_skylib//rules:common_settings.bzl", "bool_flag") #, "string_flag")

# string_flag( name = "ctng_home", build_setting_default = False)
# config_setting( name = "_ctng_home",
#                 values = ["armv8-rpi3-linux-gnueabihf",
#                           "x86_64-unknown-linux-gnu"],
# )
# DEF_FEATURE_X = select({"//:_with_feature_x": ["HAVE_FEATURE_X"],
#                         "//conditions:default": []})


# global defines
# here we use build_setting flags, just like configure's --with-foo
# and --enable-foo

# WARNING: using "defines" in c rules adds -D flags to target and
# everything that depends on it!

# defining flags involves three parts: the rule (bool_flag), the
# associated config_setting, and the selection.

# if --with_feature_x=1 is passed, then _with_feature_x will be
# true (selectable):
bool_flag( name = "with_feature_x", build_setting_default = False)
config_setting( name = "_with_feature_x",
                flag_values = {":with_feature_x": "True"})
DEF_FEATURE_X = select({"//:_with_feature_x": ["HAVE_FEATURE_X"],
                        "//conditions:default": []})
# then in cc_binary spec: defines = DEF_FEATURE_X

bool_flag(
    name = "enable_module",
    build_setting_default = False,
)


DEFLOG = select({"//config:enable_logging": ["TB_LOG"],
                 "//conditions:default": []})

DBG_THREADS = select({"//config:debug_threads": ["DEBUG_THREADS"],
	              "//conditions:default": []})

DBG_PAYLOAD = select({"//config:debug_payload": ["DEBUG_PAYLOAD"],
	              "//conditions:default": []})

DBG_TLS = select({"//config:debug_tls": ["DEBUG_TLS"],
	          "//conditions:default": []})

DBG_MSGS = select({"//config:debug_msgs": ["DEBUG_MSGS"],
	           "//conditions:default": []})

MULTIOWNER = select({"//config:multi_own": ["MULTIPLE_OWNER"],
	             "//conditions:default": []})



CROSSTOOL_NG_HOME="/Volumes/CrossToolNG"

ANDROID_SDK_ROOT="/Users/gar/sdk/android"

CSTD = select({"//config:cstd_c11" : ["-std=c11", "-x c"],
               "//config:cstd_iso9899_2011" : ["-std=iso9899:2011", "-x c"], # = c11
               "//config:cstd_c99" : ["-std=c99", "-x c"],
               "//config:cstd_iso9899_1999" : ["-std=iso9899:1999", "-x c"], # = c99
               "//config:cstd_c90" : ["-std=c90", "-x c"],
               "//config:cstd_iso9899_1990" : ["-iso9899:1990", "-x c"], # = c90
               "//conditions:default" : ["-std=c11", "-x c"]
    })

COPTS_ANDROID = ["-x c"]

TESTINCLUDES = ["-Iresource/csdk/include",
    	        "-Iresource/c_common",
		"-Iresource/c_common/ocrandom/include",
		"-Iresource/c_common/oic_malloc/include",
                "-Iresource/c_common/oic_string/include",
                "-Iresource/c_common/oic_time/include",
    	        "-Iresource/csdk/logger/include",
    	        "-Iresource/csdk/stack/include",
    	        "-Iresource/csdk/stack/include/internal",
                "-Iexternal/gtest/include",
]

OS_COPTS = select({"//config:darwin": ["-U DEBUG"],
                   "//conditions:default": []})

TESTDEPS = ["@gtest//:gtest_main",
            "//resource/c_common",
            "//resource/csdk/logger"]


# libcoap hdrs etc. require WITH_POSIX on Linux
POSIX = select({"//config:linux": ["WITH_POSIX"],
                "//config:darwin": ["WITH_POSIX"],
                "//conditions:default": []})

DEFINES = DEFDTLS + DEFTCP + DEFTLS + DEFLOG + DBG_THREADS + DBG_PAYLOAD + DBG_TLS + DBG_MSGS + MULTIOWNER + POSIX

