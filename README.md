<div align="center">

# asdf-purs ![Build](https://github.com/nsaunders/asdf-purs/workflows/Build/badge.svg) ![Lint](https://github.com/nsaunders/asdf-purs/workflows/Lint/badge.svg)

[purs](https://github.com/purescript/documentation) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add purs
# or
asdf plugin add https://github.com/nsaunders/asdf-purs.git
```

purs:

```shell
# Show all installable versions
asdf list-all purs

# Install specific version
asdf install purs latest

# Set a version globally (on your ~/.tool-versions file)
asdf global purs latest

# Now purs commands are available
purs --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/nsaunders/asdf-purs/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Nick Saunders](https://github.com/nsaunders/)
