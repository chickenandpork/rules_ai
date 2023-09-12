# Tools I've been using

## Dockerfile

I found that maintaining the requirements file specific to linux was difficult on a Mac: python simply assumes too much, and/or the magic setup.py differs so much form each developer, and each seeks to magically set up everything needed, that the host system greatly taints the result.

... so I've been maintaining //lib/python:requirements_linux.txt using a container:

```
docker build -t crossx86:latest - < tools/Dockerfile
```
... then run as:
```
docker run   --rm -it -e USER="$(id -u)" -e HOME=/tmp/bazel  -u="$(id -u)"   -v $HOME/src/rules_ai:/rules_ai   -v /tmp/build_output:/tmp/build_output   -w /rules_ai   crossx86:latest /bin/bash
I have no name!@3e66be1b7df4:/rules_ai$ mkdir ~ && bazel run //lib/python:requirements.update
```
