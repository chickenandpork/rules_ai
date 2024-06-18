#
# This is expected to be run inside a container such as:
#
# docker run   --rm -it \
#    -e USER="$(id -u)" -e HOME=/tmp/bazel  -u="$(id -u)" \
#    -v $HOME/src/rules_ai:/rules_ai   -v /tmp/build_output:/tmp/build_output   -w /rules_ai \
#    crossx86:latest /bin/bash -c tools/requirements_update.bash

mkdir ${HOME} && \
bazel run //lib/python:requirements.update && \
bazel run //lib/python:vendor_requirements
