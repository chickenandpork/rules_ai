# HuggingFace Transformer Example: test-generation, distilgpt2

In the first lesson of the HuggingFace's training, Transforms are introduced.  The first example
involves distilgpt2 as presented in this example code, except it was not marked-up in any scope.
Likely it was originally done in a Jupyter notebook, but I've wrapped in a basic Python function
for coding consistency (old-fashioned standard perhaps).

The intent here is to confirm that Huggingface libraries, and their dependencies, can be used by
the rules_ai ruleset.

This is done as an example that leverages the containing github repo; this is done so that it can
be copied and used in a stand-alone project re-using `rules_ai` code with as few changes as
possible.  Moreover, this example is built and tested during every CI of every PR to ensure it's
accurate and reliable.

## Running

```
( cd examples/huggingface-transformer-distilgpt2 && \
    bazel run //:main
)
```

## Testing

The output is not consistent or repeatable from exec to exec; there is no unittest for this example.

# Maintenance

This example uses the `vendored_requirements()` which means the common version-locked pypi
dependencies/requirements are only calculated/resolved once for the entire repo.  These examples,
and any project making use of `rules_ai`, can use those vendored requirements to accelerate the
build process.

Any dependency changes are recorded in `rules_ai//lib/pythong:requirements.in`

If that changes:
```
bazel run //lib/python:requirements.update && bazel run //lib/python:vendor_requirements
```
...if you need to run this on a linux container (for the linux-specific resolving, having no linux
baremetal online and remembering python's assumption that the build box is the deploy box), see the
instructions in tools/README.md running `docker run ... crossx86:latest ...`

## Why a vendored_requirements ?

When you build a bunch of encapsulated python things, you can end up with inconsistent behavior, or
unknowns that magically break then disappear.  By version-locking the dependencies in a
`requirements.in` file resolved to a `requirements*.txt` file per-architecture, you have much more
consistent results, and have details to help diagnose, say, "requests-x.y.z has the issue that ..."
or some such.  Then, you end up having to refetch the dependencies in a different place -- and in
Bazel, the standard download may drag out the analysis phase, so everyone downloads whether they
need it or not.

The version-locked requirements files are shared -- so the examples here and anything else that
uses `rules_ai` can use it -- and there is no resolve stage.  We lose our convenience
`requirement(requests)` in the BUILD files, but we can all cut-n-paste the pattern to build up the
venv around each build location.

We end up with the protections of version-locked files (reduce churn on dependencies, and approach
more consistent results by using a relatively constant, and signature-verified, set of dependencies)
but the cost -- resolving the requirements to a lock file -- is only taxed once on us, and someone
else (me, the maintainer) PAYS IT FOR YOU!  :)
