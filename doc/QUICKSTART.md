# Bazel Quickstart for ML Engineers

When I joined Facebook in 2015, I found the internal "buck" build tool to be this grand combination
of Make, with a real language, not some Domain-Specific Language, and awesome support for all the
things we needed in large scale development.  On leaving, and maintaining a port to Envoy (Proxy),
"Bazel" was "a buck outside of Facebook".  I was hooked, but only scratching the surface in terms
of where these tools came from and how they were related (*cough* blaze *cough*).

I've been described a bit as a Bazel Evangelist, and I'd like to help you get started in Bazel.

Now, I promise that I wrote an earlier version of this, and lemme tell you, it was awesome, but it
was my second article on Medium, and my first draft to edit later before publishing.  ..except I
must have forgitten to tell Medium that I wanted to continue working on it.  Haven't seen it since.

Dog ate my homework apparently. Turned it into a markdown in version-control.  Not gonna make that
mistake again.  Bemoaning my poor fate, let's see what version two can offer, a bit less wordy, so
you can get on your way using Bazel to get stuff done.

## Overview

We're going to do this in a few parts:

1. Grab "bazelisk"
2. Grab "ibazel"
3. Set up a ~/.bazelrc
4. build a thing
5. Take it further: caching

Of note: Bazel people are real fans of Hermetic builds: no host-based entropy getitng into the
build.  Unfortunately, ther chicken-and-egg of some scripts written in python to get the python we
want, well, that would appear to break the Hermeticity heuristic, but as a means of grabbing the
tools needed, it should not alter the build.  It just looks bad.  ...so have some sort of python3.

## Grab Bazelisk

Baselisk is this awesome tool that goes and grabs the latest `bazel` for your platform -- or a
specific version if you have a `.bazelversion` -- then passes execution to it.  Sure, the first hit
is a bazel download out of caching (but honours HTTPS_PROXY Environment variable) but later
invocations use local copies of the downloaded bazel binary.

There are a few options; personally, I grab the binary build for Mac, but take your choice:

1. If you're a GoLang dev, `go get github.com/bazelbuild/bazelisk`
2. NPM fan? `npm install -g @bazel/bazelisk`
3. Binaries -- my fave -- https://github.com/bazelbuild/bazelisk/releases

Options 1 and 2 will require some sort of softlink or alias so that "bazel" runs "bazelisk"; me, I
just download the correct bazelisk binary, and save as `bazel` in my $PATH.  Done.

```
curl -Lo /usr/local/bin/bazel "https://github.com/bazelbuild/bazelisk/releases/download/v1.18.0/bazelisk-darwin-amd64"
chmod +x /usr/local/bin/bazel
```

## Grab iBazel

If you've used `watcher` at FB, you'll see why I'm a fan of `ibazel`:  instead of
`bazel run //:main`, prefix with an "i" and it watches and runs on change: `ibazel run //:main`.

Simples.

Better: ibazel asks bazel what the source files are, and only re-runs builds if the dependencies of
the target(s) you mention are changed -- not necessarily wathcing every file in the directory.

Awesomesauce.

Go get `bazel-watcher`, save as `ibazel`:

```
curl -Lo /usr/local/bin/ibazel "https://github.com/bazelbuild/bazel-watcher/releases/download/v0.23.7/ibazel_darwin_amd64"
chmod +x /usr/local/bin/ibazel
```

## Check your work so far

1. Check that `ibazel` is responding, and gives a version similar to the one in your download:
```
$ ibazel version 2>&1 | head -1
iBazel - Version v0.23.7
```

2. Check that `bazel` is responding (as bazelisk) and shows both versions:
```
$ bazel version 2>&1 | head -2 
Bazelisk version: v1.18.0
Build label: 6.3.2
```
Note there that `bazelisk` version 1.18.0 is defaulting to use bazel-6.3.2 (latest as of writing)
to get the job done.  Superb, you're almost set.

## Set up a basic ~/.bazelrc

Many people customize their terminals and environments; I never did (from a dark past of jumping to
newly-built machines, slow NFS automount homes, etc).  Even with my "work with defaults, they're
character-building" habit, there are a few bazel configs worth setting up:

`(${HOME}/.bazelrc)`
```
common --incompatible_strict_action_env
common --action_env=TRANSFORMERS_CACHE=/tmp/huggingface-transformers-cache
common --disk_cache=/Users/allanc/.cache/bazel-disk-cache
common --verbose_failures

# a bitmore info on `bazel query //...` -like queries
query --output=label_kind

# Will write to STDOUT the results of a test failure when they occur
test --test_output=errors
test --test_summary=detailed
```
The "common" configs apply to build/test/run, and used to cause a problem with (IIRC) `ibazel`, but
seems OK now.

## Build a thing

Hey, wanna do some LLMs?  Try this:

```
git clone https://github.com/chickenandpork/rules_ai ~/src/rules_ai && \
  cd ~/src/rules_ai/examples/huggingface_transformer_named_entity_recognition && \
  bazel run //:main
```

You'll see something like this (some lines abbreviated, JSON formatted at the end), and notice that
the first build & run takes ~2.5 minutes to pull all resources and build:

```
$ (cd ~/src/rules_ai/examples/huggingface_transformer_named_entity_recognition && bazel run //:main )
INFO: Analyzed target //:main (36 packages loaded, 17463 targets configured).
INFO: Found 1 target...
Target //:main up-to-date:
  bazel-bin/main
INFO: Elapsed time: 144.148s, Critical Path: 4.59s
INFO: 4 processes: 4 internal.
INFO: Build completed successfully, 4 total actions
INFO: Running command line: bazel-bin/main
No model was supplied, ...
Using a pipeline without ...
Some weights of the model ...
/private/var/...  token_classification.py:169: UserWarning: `grouped_entities` is deprecated and
will be removed in version v5.0.0, defaulted to `aggregation_strategy="simple"` instead.
Result: [
    {'entity_group': 'PER', 'score': 0.9996722, 'word': 'Allan Clark', 'start': 7, 'end': 18},
    {'entity_group': 'LOC', 'score': 0.99831665, 'word': 'Seattle', 'start': 24, 'end': 31},
    {'entity_group': 'MISC', 'score': 0.90329456, 'word': 'Bazel', 'start': 48, 'end': 53},
    {'entity_group': 'ORG', 'score': 0.9920346, 'word': 'Apple', 'start': 62, 'end': 67},
    {'entity_group': 'ORG', 'score': 0.8777158, 'word': 'Snap', 'start': 69, 'end': 73},
    {'entity_group': 'ORG', 'score': 0.980426, 'word': 'BCAI', 'start': 79, 'end': 83}
]
```

There's more to show in this example, but this example at least shows how to build.  More
importantly, it shows that your Bazel is working.

If you rebuild, or make a change to main.py and rebuild, you'll notice that nothign is re-fetched,
most build targets are used in-place, only the things that were affected get rebuilt.

Next, try iBazel

## Build a thing automatically

So, to foreshadow a bit, I *have* done this to automatically build and deploy new versions of a
microservice whenever a dependency changes:

```
ibazel run //service/incident-record-service/qa:deploy
```

... but we should walk before running.  Instead, in one terminal, try this:
```
cd ~/src/rules_ai/examples/huggingface_transformer_named_entity_recognition
ibazel run :main
```

This will ask `bazel` some things, then run `bazel` to do a build, actually running `bazelisk`
which gets and runs `bazel` for us.  This can burble away for a few minutes if it's your first
build of the directory in a while.

In another terminal, edit `main.py` and change the like that looks like:
```
    rec = recognizer(
        "Hi I'm Allan Clark from Seattle, and I used the Bazel tool at Apple, Snap, and BCAI"
    )
```

Change it to be some other test involving proper names, locations, etc.  When you save it in one
terminal, the `ibazel` terminal should spring to life, and rebuild/run the affected binary.

Now do the same, but add a terminal running `ibazel test //...` -- you'll see that the two `ibazel`
binaries hungry-hippo themselves to grab the build, Second-place shows a message that it's waiting,
and when the first build is done, the second goes on its way.  I usually have 2 or 3 `ibazel`
terminals running while I poke at a thing to constantly retest the world when I make a change.

`ibazel` doesn't seem to successfully watch from inside of a docker container: running a basic
ubuntu lets you build for linux on your Mac, but `ibazel` won'trebuild automatically when you make
changes in the host on the affected files served into the container.  ..that I know of.  Doesn't
work for me.

## Cache, Cache, Cache

TBD
