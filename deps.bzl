# Rules to supply what the user hasn't alreayd overridden.
#
# The intent is for a simplification of what the user needs to maintain.

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


def _python_toolchains_and_requirements_impl(repository_ctx):
    """Produce a virtual repository that templates out a bzl file for exercise (we cannot load() a
    non-constant string as a resource)

    Args:
       repository_ctx: repository context from which to read OS

    Rule Args:
       - TBD

    """

    repository_ctx.file("BUILD", content = 'exports_files(["python_toolchain_and_requirements.bzl"])', executable = False)
    lockfiles={
        "darwin": "//lib/python:requirements_darwin.txt",
        "linux": "//lib/python:requirements_linux.txt",
        "default": "//lib/python:requirements_default.txt",
    }

    repository_ctx.file("python_toolchain_and_requirements.bzl", content = "\n".join(
        [
"""load("@{}//:defs.bzl", "interpreter")""".format(repository_ctx.attr.python_repo_name),
"""load("@{}//:requirements.bzl", "install_deps")""".format(repository_ctx.attr.pypi_repo_name),
"""load("@rules_python//python:pip.bzl", "pip_parse")""",
"""load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")""",
"",
"""def python_toolchains_and_requirements(lockfiles=None):""",
"",
"""    py_repositories()""",
"",
"""    python_register_toolchains(""",
"""        name = "{}",""".format(repository_ctx.attr.python_repo_name),
"""        python_version = "{}",""".format(repository_ctx.attr.python_version),
"""    )""",
"",
"""    if lockfiles:""",
"""        pip_parse(""",
"""            name = "{}",""".format(repository_ctx.attr.pypi_repo_name),
"""            python_interpreter_target = interpreter,""",
"""            requirements_darwin = "//lib/python:requirements_darwin.txt",""",
"""            requirements_linux = "//lib/python:requirements_linux.txt",""",
"""            requirements_lock = "//lib/python:requirements.txt",""",
"""        )""",
"",
"""    # Initialize repositories for all packages in requirements_lock.txt.""",
"""    install_deps()""",
"",
    ]))

python_toolchains_and_requirements = repository_rule(
    implementation = _python_toolchains_and_requirements_impl,
    local = True,
    attrs={
        "pypi_repo_name": attr.string(default="Xpypi"),
        "python_repo_name": attr.string(default="Xpython39"),
        "python_version": attr.string(default="3.9"),
    }
)


def dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "rules_python",
        patches = [
            "@rules_ai//bzl/patches:chickenandpork-i686-mostly-acts-like-x86_64.patch",

            # https://github.com/bazelbuild/rules_python/pull/1166 not yet merged; I'd like to use:
            # (in pip_parse())
            # requirement_clusters = {
            #     "torch-triton": [
            #         "torch",
            #         "triton",
            #     ]}
            # ... but PR1166 not yet merged.  nkey0's workaround hardcoding triton and torch
            "@rules_ai//bzl/patches:nkey0-circulardeps.patch",  # https://github.com/bazelbuild/rules_python/pull/1166#issuecomment-1701230930
        ],
        sha256 = "5868e73107a8e85d8f323806e60cad7283f34b32163ea6ff1020cf27abef6036",
        strip_prefix = "rules_python-0.25.0",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.25.0/rules_python-0.25.0.tar.gz",
    )
