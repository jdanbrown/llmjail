# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
# Docs: https://docs.docker.com/build/checks/#skip-checks
# - SecretsUsedInArgOrEnv -- don't warn on secrets in ARG/ENV

# Installing swift is a pita, so just base from their docker images instead
# - https://www.swift.org/install/linux/
# - https://www.swift.org/install/linux/docker/
# - https://hub.docker.com/_/swift
#   - swift:6.1-noble -> FROM ubuntu:24.04
#     - https://github.com/swiftlang/swift-docker/blob/main/6.1/ubuntu/24.04/Dockerfile
# FROM ubuntu:24.04
FROM swift:6.1-noble

WORKDIR "/root"

ARG GH_TOKEN
ENV GH_TOKEN=$GH_TOKEN

# Don't clean up after `apt update`, since it makes interactive docker dev a pain
RUN apt update
RUN apt install -y --no-install-recommends \
  coreutils \
  curl \
  eza \
  fd-find \
  findutils \
  fish \
  git \
  gh \
  jq \
  just \
  python-is-python3 \
  python3 \
  python3-pip \
  ripgrep \
  sed \
  swift \
  tree \
  wget

# Ubuntu installs fd as fdfind, so symlink it as fd
RUN ln -s /usr/bin/fdfind /usr/local/bin/fd

# Python packages
RUN pip install --no-cache-dir --break-system-packages \
  glances \
  httpie \
  ruff \
  pytest

# Swift packages
RUN wget https://github.com/nicklockwood/SwiftFormat/releases/download/0.58.7/swiftformat_linux.zip \
 && unzip swiftformat_linux.zip \
 && mv swiftformat_linux swiftformat \
 && mv swiftformat /usr/local/bin/ \
 && chmod a+x /usr/local/bin/swiftformat \
 && rm -rf swiftformat_linux.zip
