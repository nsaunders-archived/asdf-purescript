#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for purs.
GH_REPO="https://github.com/purescript/purescript"

fail() {
  echo -e "asdf-purs: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if purs is not hosted on GitHub releases.
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
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if purs has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # TODO: Adapt the release URL convention for purs
  url="$GH_REPO/archive/v${version}.tar.gz"

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

  # TODO: Adapt this to proper extension and adapt extracting strategy.
  local release_file="$install_path/purs-$version.tar.gz"
  (
    mkdir -p "$install_path"
    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$install_path" --strip-components=1 || fail "Could not extract $release_file"
    rm "$release_file"

    # TODO: Asert purs executable exists.
    local tool_cmd
    tool_cmd="$(echo "purs --help" | cut -d' ' -f2-)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "purs $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing purs $version."
  )
}
