# Contributing

Testing Locally:

```shell
asdf plugin-test purescript https://github.com/nsaunders/purescript [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin-test purescript https://github.com/nsaunders/asdf-purescript.git "purs --help"
```

Tests are automatically run in GitHub Actions on push and PR.
