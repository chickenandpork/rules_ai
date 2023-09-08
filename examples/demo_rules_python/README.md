# Basic Build

It's a habit of mine to include a basic build as part of a project; this allows me to immediately
ensure the toolchains are functional and can detect sudden critical issues with the main branch's
ability to build and test

This is almost identical to the example in rules_python, notably:
 - https://github.com/bazelbuild/rules_python/blob/main/examples/pip_parse @018e355
