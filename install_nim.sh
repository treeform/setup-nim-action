#!/bin/bash

set -eu

move_nim_compiler() {
  src_dir="$1"
  dst_dir="$2"
  if [[ -d "$dst_dir" ]]; then
    echo "remove cached directory (path = $dst_dir)"
    rm -rf "$dst_dir"
  fi
  mv "$src_dir" "$dst_dir"
}

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

# download nim compiler
arch="x64"
if [[ "$os" = Windows ]]; then
  download_url="https://nim-lang.org/download/nim-${nim_version}_${arch}.zip"
  curl -sSL "${download_url}" > nim.zip
  unzip -q nim.zip
  rm -f nim.zip
elif [[ "$os" = macOS ]]; then
  # need to build compiler
  download_url="https://nim-lang.org/download/nim-${nim_version}.tar.xz"
  curl -sSL "${download_url}" > nim.tar.xz
  tar xf nim.tar.xz
  rm -f nim.tar.xz
  cd "nim-${nim_version}"
  echo "build nim compiler"
  ./build.sh
  echo "build koch tool"
  ./bin/nim c --noNimblePath --skipUserCfg --skipParentCfg --hints:off koch
  echo "koch boot"
  ./koch boot -d:release --skipUserCfg --skipParentCfg --hints:off
  echo "koch tools"
  ./koch tools --skipUserCfg --skipParentCfg --hints:off
  cd ..
else
  download_url="https://nim-lang.org/download/nim-${nim_version}-linux_${arch}.tar.xz"
  curl -sSL "${download_url}" > nim.tar.xz
  tar xf nim.tar.xz
  rm -f nim.tar.xz
fi
move_nim_compiler "nim-${nim_version}" "${nim_install_dir}"
