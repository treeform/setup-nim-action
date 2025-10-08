#!/bin/bash

set -eu

# parse commandline args
nim_version="2.2.4"
os="Linux"
while ((0 < $#)); do
  opt=$1
  shift
  case $opt in
    --nim-version)
      nim_version=$1
      ;;
    --os)
      os=$1
      ;;
  esac
done

echo "install nim $nim_version"

# prepare install directory
nim_install_dir="$HOME/.nim_runtime"
echo "nim install directory: $nim_install_dir"
mkdir -p $nim_install_dir
original_dir="$PWD"
cd $nim_install_dir

# download nim compiler
arch="x64"
if [[ "$os" = Windows ]]; then
  curl -sSL "https://nim-lang.org/download/nim-${nim_version}_${arch}.zip" > nim.zip
  unzip -q nim.zip --strip-components=1
elif [[ "$os" = macOS ]]; then
  # need to build compiler
  curl -sSL "https://nim-lang.org/download/nim-${nim_version}.tar.xz" > nim.tar.xz
  tar xf nim.tar.xz --strip-components=1
  echo "build nim compiler"
  ./build.sh
  echo "build koch tool"
  ./bin/nim c --noNimblePath --skipUserCfg --skipParentCfg --hints:off koch
  echo "koch boot"
  ./koch boot -d:release --skipUserCfg --skipParentCfg --hints:off
  echo "koch tools"
  ./koch tools --skipUserCfg --skipParentCfg --hints:off
else
  curl -sSL "https://nim-lang.org/download/nim-${nim_version}-linux_${arch}.tar.xz" > nim.tar.xz
  tar xf nim.tar.xz --strip-components=1
fi

cd "$original_dir"
