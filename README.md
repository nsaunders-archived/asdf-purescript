<div align="center">

# asdf-purescript ![Build](https://github.com/nsaunders/asdf-purescript/workflows/Build/badge.svg) ![Lint](https://github.com/nsaunders/asdf-purescript/workflows/Lint/badge.svg)

[PureScript](https://github.com/purescript/documentation) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

# Dependencies

The only dependencies are `bash`, `curl`, and `tar`.

# Install

Plugin:

```shell
asdf plugin-add purescript
# or
asdf plugin-add https://github.com/nsaunders/asdf-purescript.git
```

Installation:

```shell
# Show all installable versions.
asdf list-all purescript

# Install specific version.
asdf install purescript latest

# Set a version globally (on your ~/.tool-versions file).
asdf global purescript latest

# Now purs command is available.
purs --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install and manage versions.
