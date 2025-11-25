# Based on:
# - https://chatgpt.com/share/6924c889-a0dc-8009-b089-2b81fead250c

FROM cicirello/alpine-plus-plus:latest

ARG GH_TOKEN
ENV GH_TOKEN=$GH_TOKEN

RUN apk add --no-cache \
  coreutils \
  curl \
  fd \
  findutils \
  git \
  github-cli \
  jq \
  py3-pip \
  pytest \
  python3 \
  ripgrep \
  sed \
  tree
