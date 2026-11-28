FROM ubuntu:26.04

RUN apt update && apt install -y --no-install-recommends \
  build-essential \
  gcc \
  gdb \
  make \
  git \
  check \
  pkg-config \
  netcat-openbsd \
  valgrind \
  && rm -rf /var/lib/apt/lists/*
