FROM --platform=linux/x86_64 python:bullseye

RUN mkdir -p /usr/bin && curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 && chmod +x /usr/bin/bazel
RUN mkdir -p /usr/bin && curl -Lo /usr/bin/ibazel https://github.com/bazelbuild/bazel-watcher/releases/download/v0.23.7/ibazel_linux_amd64 && chmod +x /usr/bin/ibazel

#RUN mkdir /home/bazel
#RUN chown -R 501:1 /home/bazel
#ENV HOME=/home/bazel
