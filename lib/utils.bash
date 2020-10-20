#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/purescript/purescript"

fail() {
  echo -e "asdf-purs: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename bin url
  version="$1"
  filename="$2"

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    bin="linux64"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    bin="macos"
  else
    fail "unrecognized operating system $OSTYPE"
  fi

  # https://github.com/purescript/purescript/releases/download/v0.13.8/linux64.tar.gz
  url="$GH_REPO/releases/download/v${version}/${bin}.tar.gz"

  echo "* Downloading purs release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-purs supports release installs only"
  fi

  local release_file="$install_path/purs-$version.tar.gz"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$install_path" --strip-components=1 purescript/purs || fail "Could not extract $release_file"
    mv "$install_path/purs" "$install_path/bin"
    rm "$release_file"

    local tool_cmd
    tool_cmd="$(echo "purs --help" | cut -d' ' -f2-)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "purs $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing purs $version."
  )
}
