# AL / ML Rules for Bazel

## Overview

This repository is a set of workarounds and convenience functions to facilitate Large Language
Models through Bazel.  Although there are great ambitiond, it's currently a fairly modest offer
yet, focusing on simplifying the library definition, tracking OS-specific differences, and reducing
the per-repository load.

Documentation is mostly from Examples in ./examples/ directory.

Examples in ./examples/ are built with every PR to ensure that that they accurately represent
functional demonstrations: pay attention to the comment around local_repository() in each
directory's WORKSPACE, but otherwise the intent is that you can cut-n-paste and immediately build
without other changes.

## Bzlmod

Rules_ai does not currently use bzlmod: in switching, the python resources have different names,
which breaks much of the vendored requirements.  Resolving this is a later goal.

## Getting Started

In order to use rules_ai to simply build -- for example, a LangChain implementation -- start with
the WORKSPACE file:

### WORKSPACE

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "rules_ai",
    commit = "29485f606d3309c8e6059e39e42e4578c10d01a2",
    remote = "https://github.com/chickenandpork/rules_ai",
)

load("@rules_ai//:deps.bzl", rules_ai_dependencies = "dependencies")

rules_ai_dependencies()  # define before use of python_defs.bzl

load("@rules_ai//:python_defs.bzl", rules_ai_py_toolchain = "py_toolchain")

rules_ai_py_toolchain(python_version = "3.9", python_repo_name = "python39")

# Load a pre-curated set of default per-OS requirements, naming the repo "pypi", then (a standard
# step of "rules_python" use) install the dependencies defined in this vendored requirements spec

load("@rules_ai//:requirements.bzl", "vendored_requirements")

vendored_requirements(name = "pypi")

load("@pypi//:requirements.bzl", "install_deps")

install_deps()
```
Notice that:
1. we set the python version, and a "python39" label; later, this is "@python39"
2. we use `vendored_requirements(name = "pypi")`, which defines our "@pypi" for the following
    `load("@pypi...)` command

In this way, we have a version-locked python implementation, and a version-locked set of python
dependnecies form a standard "requirements.in" file.

Next, define a BUILD.bazel file:
### BUILD.bazel

```
load("@pypi//:requirements.bzl", "requirement")
load("@rules_python//python:defs.bzl", "py_binary", "py_test")

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = [
        "@pypi_torch//:pkg",
        "@pypi_transformers//:pkg",
    ],
)

py_test(
    name = "test",
    size = "small",
    srcs = ["test.py"],
    deps = [":main"],
)
```
These `py_binary` and `py_test` methods are standard `rules_python`, and if you copied the
WORKSPACE above and didn't define a `rules_python`, `rules_ai_dependencies()` do so for you.

For every `import torch` or `from transformers import pipeline`, for any library "libname" that you
need, you have to set `deps` to include "@pypi_{libname}//:pkg".  This will get cleaned up into the
`requirement()` function.

NOTE that the `requirement` from `@pypi//:requirements.bzl` is not yet used; I'd like to return to
that, but it has some oddities to resolve.

Now, just write some python, such as a `main.py` as shown in the `srcs=` of the `py_binary()` config:

### main.py
```
from transformers import pipeline, pipelines

def recognize() -> pipelines.token_classification.TokenClassificationPipeline:
    return pipeline(
        "ner",  # ner == Named Entity Recognition
        grouped_entities=True,  # this causes words like "Allan Clark" to remain grouped
    )

def main():
    # Instantiate the pipeline
    recognizer = recognize()

    # Exercise the pipeline
    rec = recognizer(
        "Hi I'm Allan Clark from Seattle, and I used the Bazel tool at Apple, Snap, and BCAI"
    )
    print(f"Result: {rec}")

if __name__ == "__main__":
    main()
```

This is a fairly standard python file, a really simplified version of what you'd use for a
LangChain from Huggingface.  The Named_Entity_Recognizer here is similar to the examples/ directory
demonstrates.  `rec = recogniser(...)` is probably what you'd replace with additional text to scan
and produce recognized entities.

Of course, if you really loved it, you'd unittest it, so:

### test.py

```
import unittest

import main  # our main.py, available because py_test(name="test",..) has deps=[":main"]

# transformers is available because py_test() has deps=[":main"], and py_binary(name="main",...)
# has deps = [ "@pypi_transformers//:pkg", ],

from transformers import pipelines

class ExampleTest(unittest.TestCase):
    def test_main(self):
        recognizer = main.recognize()  #defined in main.py

        self.assertIsInstance(
            recognizer, pipelines.token_classification.TokenClassificationPipeline
        )

        # Exercise/acivate the pipeline
        recognize = recognizer(
            "Hi I'm Allan Clark from Seattle, and I used the Bazel tool at Apple, Snap, and BCAI"
        )

        self.assertIs(type(recognize), list)  # result is a list of dicts
        self.assertIs(type(recognize[0]), dict)

        # this is not reliable in general; empirically, the model gave me 6 tokens
        self.assertEqual(len(recognize), 6)


if __name__ == "__main__":
    unittest.main()
```

### Running your first program

`bazel build //...` of course builds everything,
`bazel test //...` of course tests everything (all one unittests)
`bazel run :main` will run the resulting `bazel-bin/main`:

It may look like this (NOTE: 45 second runtime -- mostly spent loading data):
```
$ time ./bazel-bin/main
No model was supplied, defaulted to ...
...
Result: [
    {'entity_group': 'PER', 'score': 0.9996722, 'word': 'Allan Clark', 'start': 7, 'end': 18},
    {'entity_group': 'LOC', 'score': 0.99831665, 'word': 'Seattle', 'start': 24, 'end': 31},
    {'entity_group': 'MISC', 'score': 0.90329456, 'word': 'Bazel', 'start': 48, 'end': 53},
    {'entity_group': 'ORG', 'score': 0.9920346, 'word': 'Apple', 'start': 62, 'end': 67},
    {'entity_group': 'ORG', 'score': 0.8777158, 'word': 'Snap', 'start': 69, 'end': 73},
    {'entity_group': 'ORG', 'score': 0.980426, 'word': 'BCAI', 'start': 79, 'end': 83}
]

real	0m44.626s
user	0m23.808s
sys	0m6.634s
```
