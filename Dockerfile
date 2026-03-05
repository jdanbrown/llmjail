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
ENV HOME="/root"

# Run `apt update` separately for faster iteration
# Run `apt update` again with `apt install`, to avoid stale package caches on `apt install`
# Don't clean up after `apt update`, since it makes interactive docker dev a pain
RUN apt update
RUN apt update && apt install -y --no-install-recommends \
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
  pipx \
  python-is-python3 \
  python3 \
  python3-pip \
  ripgrep \
  sed \
  swift \
  tree \
  wget \
  xz-utils

# Ubuntu installs fd as fdfind, so symlink it as fd
RUN ln -s /usr/bin/fdfind /usr/local/bin/fd

# Install node
# - This is apparently the typical way to do it 🤷
# - Set ARCH dynamically (arm64 for docker on macos/apple, amd64 for linux/intel)
ARG NODE_VERSION=24.14.0
RUN ARCH=$(dpkg --print-architecture | sed 's/amd64/x64/') \
  && curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" \
  | tar -xJ --strip-components=1 -C /usr/local

# Python packages
RUN pip install --no-cache-dir --break-system-packages \
  glances \
  httpie \
  ruff \
  pytest \
  uv

# Node packages
RUN npm -g install \
  pyright

# Swift packages
RUN wget https://github.com/nicklockwood/SwiftFormat/releases/download/0.60.0/swiftformat_linux.zip \
 && unzip swiftformat_linux.zip \
 && mv swiftformat_linux swiftformat \
 && mv swiftformat /usr/local/bin/ \
 && chmod a+x /usr/local/bin/swiftformat \
 && rm -rf swiftformat_linux.zip

# fly.io
# - https://fly.io/docs/flyctl/install/
# - idk why it doesn't have an apt package :/
RUN curl -L https://fly.io/install.sh >/tmp/fly-install.sh && bash /tmp/fly-install.sh --non-interactive
ENV FLYCTL_INSTALL="$HOME/.fly"
ENV PATH="$FLYCTL_INSTALL/bin:$PATH"

# Args -> env/secrets
ARG GH_TOKEN
ENV GH_TOKEN=$GH_TOKEN
ARG FLY_API_TOKEN
ENV FLY_API_TOKEN=$FLY_API_TOKEN
