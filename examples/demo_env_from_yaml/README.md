# Basic Build

This example demonstrates setting env variables from a plaintext YAML file.

Why?

Many of the ML/LLM tools and features use credentials injected as global environment values; this
allows for simple examples of the form `OPENAI_API_KEY=sk-loremipsum... ./run/my/thing`, knowing
that the libraries used will look to the env for the keys it needs.

Personally, I find some issue in hidden exceptions and unreported errors or preflight checks that
do not indicate the issue where it occurs, but show indirect signal later that something is amiss.
Debugging this is suboptimal and wasteful.  There should be a way to check that each component has
what it's looking for, or gracefully raising an exception for handling, but THIS!  IS!  PYTHON!

SOPS has the notion of keeping environment variables in a file that is encrypted in the source
tree; this means that boilerplate often either sources that file, tainting the entire environment
with all keys and crews in that file, or the same code over and over to pull text values form a
file and inject to the env in a wrapper.

Generating that wrapper offers simpler coding, less code to maintain.

Taking values from a plaintext file shows how that works aside from the added complexity of SOPS,
and could be used ot leverage a shared .env file.
