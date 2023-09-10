entrypoints = ["data_requirement", "dist_info_requirement", "entry_point", "install_deps", "requirement", "whl_requirement"]

def _vendored_requirements_impl(repository_ctx):
    """Produce a virtual repository that redirects to the vendored reuirements.txt file pertaining to the OS.

    Args:
       repository_ctx: repository context from which to read OS

    In order to simplify the use of a vendored requirements file -- one that corresponds to the OS
    (Hi, Nvidia linux-only stuff, I see you) -- we need to access the OS in a logic statement to
    select the right set of symbols.  I didn't see how to do that in a WORKSPACE, so I went with
    the effort of a repository_rule() to act as a facade to select the correct underlying
    implementation.  Perhaps the facade pattern will also allow me to change the underlying
    implementation, or even bring in arch (x64_64, aarch64) without code changes in usage.

    In the short-term, this complexity is warranted to avoid user-selection through some sort of
    select or hard-coded value to select the correct requirements.bzl based on a requirements.txt
    """

    _REQUIREMENTS = {
        "mac os x": "@rules_ai//lib/gen:requirements_darwin.bzl",  # not "darwin" or "macos", a brand new constant
        "linux": "@rules_ai//lib/gen:requirements_linux.bzl",
        "windows": "@rules_ai//lib/gen:requirements_windows.bzl",
    }

    requirements = _REQUIREMENTS[repository_ctx.os.name]
    repository_ctx.file("BUILD", content = 'exports_files(["requirements.bzl"])', executable = False)
    repository_ctx.file("requirements.bzl", content = "\n".join(
        [
            'load("{}", '.format(_REQUIREMENTS[repository_ctx.os.name]),
        ] + [
            '    _{}="{}",'.format(s, s)
            for s in entrypoints
        ] + [
            ")",
            "",
        ] + [
            "{}=_{}".format(s, s)
            for s in entrypoints
        ],
    ))

vendored_requirements = repository_rule(
    implementation = _vendored_requirements_impl,
    local = True,
)
