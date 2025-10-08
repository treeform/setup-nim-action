# setup-nim-action

![Build Status](https://github.com/treeform/setup-nim-action/workflows/build/badge.svg)

This action sets up a [Nim-lang](https://nim-lang.org/) environment in the most simple way.

Originally forked from [jiro4989/setup-nim-action](https://github.com/jiro4989/setup-nim-action) but simplified.

## Usage:
```
name: Github Actions
on: [push, pull_request]
jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        version: [2.2.4, 2.2.2, 2.2.0, 2.0.16]

    runs-on: ${{ matrix.os }}

    steps:
    - uses: actions/checkout@v3
    - uses: treeform/setup-nim-action@v1
      with:
        repo-token: ${{ secrets.GITHUB_TOKEN }}
    - run: nimble test -y
```

Warning: `devel` or `stable` is not supported, exact released version is required.
