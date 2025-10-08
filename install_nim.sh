#!/bin/bash

set -eu

# parse commandline args
nim_version="2.2.4"
nim_install_dir="$HOME/.nim_runtime"
os="Linux"
while ((0 < $#)); do
  opt=$1
  shift
  case $opt in
    --nim-version)
      nim_version=$1
      ;;
    --nim-install-directory)
      nim_install_dir=$1
      ;;
    --os)
      os=$1
      ;;
  esac
done

echo "install nim $nim_version"

# prepare install directory
mkdir -p "$nim_install_dir"

# download nim compiler
arch="x64"
if [[ "$os" = Windows ]]; then
  download_url="https://nim-lang.org/download/nim-${nim_version}_${arch}.zip"
  curl -sSL "${download_url}" > nim.zip
  unzip -q nim.zip --strip-components=1 -d "$nim_install_dir" 
elif [[ "$os" = macOS ]]; then
  # need to build compiler
  download_url="https://nim-lang.org/download/nim-${nim_version}.tar.xz"
  curl -sSL "${download_url}" > nim.tar.xz
  tar xf nim.tar.xz --strip-components=1 -C "$nim_install_dir"
  cd "$nim_install_dir"
  echo "build nim compiler"
  ./build.sh
  echo "build koch tool"
  ./bin/nim c --noNimblePath --skipUserCfg --skipParentCfg --hints:off koch
  echo "koch boot"
  ./koch boot -d:release --skipUserCfg --skipParentCfg --hints:off
  echo "koch tools"
  ./koch tools --skipUserCfg --skipParentCfg --hints:off
else
  download_url="https://nim-lang.org/download/nim-${nim_version}-linux_${arch}.tar.xz"
  curl -sSL "${download_url}" > nim.tar.xz
  tar xf nim.tar.xz --strip-components=1 -C "$nim_install_dir"
fi
