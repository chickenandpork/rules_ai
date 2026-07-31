# hadolint global ignore=DL3008,DL3029
FROM --platform=linux/x86_64 ubuntu@sha256:19478ce7fc2ffbce89df29fea5725a8d12e57de52eb9ea570890dc5852aac1ac

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl gcc python3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/bin && curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 && chmod +x /usr/bin/bazel
RUN mkdir -p /usr/bin && curl -Lo /usr/bin/ibazel https://github.com/bazelbuild/bazel-watcher/releases/download/v0.23.7/ibazel_linux_amd64 && chmod +x /usr/bin/ibazel

#RUN mkdir /home/bazel
#RUN chown -R 501:1 /home/bazel
#ENV HOME=/home/bazel
