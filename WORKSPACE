workspace(name = "rules_ai")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load("@rules_ai//:deps.bzl", rules_ai_dependencies = "dependencies", "python_toolchains_and_requirements")

rules_ai_dependencies()

python_toolchains_and_requirements(name="ptar", python_version = "3.9", python_repo_name="python39", pypi_repo_name = "pypi")

load("@ptar//:python_toolchain_and_requirements.bzl", ptar="python_toolchains_and_requirements")
ptar()

#python_toolchains_and_requirements((python_version = "3.9", python_repo_name="python39", pypi_repo_name = "pypi", lockfiles={
#    "darwin": "//lib/python:requirements_darwin.txt",
#    "linux": "//lib/python:requirements_linux.txt",
#    "default": "//lib/python:requirements.txt",
#})


#load("@rules_ai//:toolchains.bzl", rules_ai_register_toolchains = "register_toolchains")
#
#rules_ai_register_toolchains (python_version = "3.9", python_repo_name="python39", pypi_repo_name = "pypi", lockfiles={
#    "darwin": "//lib/python:requirements_darwin.txt",
#    "linux": "//lib/python:requirements_linux.txt",
#    "default": "//lib/python:requirements.txt",
#})




load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")

py_repositories()

python_register_toolchains(
    name = "python39",
    python_version = "3.9",
)

load("@python39//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "pypi",
    python_interpreter_target = interpreter,
    requirements_darwin = "//lib/python:requirements_darwin.txt",
    requirements_linux = "//lib/python:requirements_linux.txt",
    requirements_lock = "//lib/python:requirements.txt",
)

load("@pypi//:requirements.bzl", "install_deps")

# Initialize repositories for all packages in requirements_lock.txt.
install_deps()
