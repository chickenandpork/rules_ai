# After a call to "deps()" defines external repositories that might not be defined/overridden by
# the user, this file collects some python setup functions.
#
# The intent is for a simplification of what the user needs to maintain.

load("@rules_python//python:repositories.bzl", "py_repositories")
load("@rules_python//python:repositories.bzl", "python_register_toolchains")
load("@rules_python//python/pip_install:repositories.bzl", "pip_install_dependencies")

def py_toolchain(python_version = "3.9", python_repo_name = "python39"):
    py_repositories()

    # Set up a python-3.9 toolchain, then use that interpreter for the @pypi dependency based on resolving the requirements_lock file
    python_register_toolchains(name = python_repo_name, python_version = python_version)

    # Because we drop out the pip_parse(), we need to explicitly call one of the magic hidden helper-functions:
    pip_install_dependencies()


