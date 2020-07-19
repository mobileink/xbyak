# platforms/BUILD


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
    return ArchProvider(arch = raw_arch)

arch_opt = rule(
    implementation = arch_impl,
    build_setting = config.string(flag = True)
    # NB: no attrib, no default?
)

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

