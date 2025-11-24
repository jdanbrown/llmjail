# Based on:
# - https://chatgpt.com/share/6924c889-a0dc-8009-b089-2b81fead250c

FROM cicirello/alpine-plus-plus:latest

RUN apk add --no-cache \
  coreutils \
  findutils \
  sed \
  git \
  curl \
  ripgrep \
  jq \
  fd \
  tree \
  python3 \
  py3-pip \
  pytest
