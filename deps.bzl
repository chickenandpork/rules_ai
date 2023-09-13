# Rules to supply what the user hasn't alreayd overridden.
#
# The intent is for a simplification of what the user needs to maintain.

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

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
