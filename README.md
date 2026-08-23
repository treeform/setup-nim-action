# setup-nim-action

![Build Status](https://github.com/treeform/setup-nim-action/workflows/build/badge.svg)

This action sets up a [Nim-lang](https://nim-lang.org/) environment using [Nimby](https://github.com/treeform/nimby).

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
        version: [2.2.10, 2.2.6, 2.2.4, 2.0.16]

    runs-on: ${{ matrix.os }}

    steps:
    - uses: actions/checkout@v5
    - uses: treeform/setup-nim-action@v6
    - run: nimby -v
```

Warning: `devel` or `stable` is not supported, exact released version is required.

## Installing packages

Nimby installs packages as siblings of the workspace root, so the workspace has
to live outside your repository. Since Nimby 0.2.0 it refuses to create one
inside a Git checkout or a Nimble package rather than scattering package
directories into your repo:

```
No Nimby workspace found.
Refusing to create one inside package or Git checkout: /home/runner/work/myrepo/myrepo
Run `nimby create` in the directory you want as the workspace.
```

Create the workspace in the *parent* of the checkout, so your repository sits
inside it alongside its dependencies:

```
    steps:
    - uses: actions/checkout@v5
    - uses: treeform/setup-nim-action@v6

    - name: Install dependencies
      shell: bash
      run: |
        cd ..
        nimby create
        nimby install jsony

    - run: nim c tests/tests.nim
```

The parent matters. Nim finds `nim.cfg` by walking up from the file it is
compiling, so a workspace somewhere else, such as under `RUNNER_TEMP`, will
install the packages but your own build will not see them.
