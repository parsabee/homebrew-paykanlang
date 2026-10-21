# Homebrew tap for PaykanLang

```sh
brew install parsabee/paykanlang/paykanlang
paykan --version
```

`brew install` taps this repository by itself; `brew tap parsabee/paykanlang` does it ahead
of time. The formula installs the prebuilt tarball of the
[PaykanLang release](https://github.com/parsabee/PaykanLang/releases) for the platform
(macOS on Apple Silicon, Linux on x86-64 and ARM64): `paykan` links LLVM statically, so
nothing is built on your machine. `paykan build` links programs with the system C compiler.

## How the formula is updated

The compiler's Release workflow opens a pull request here for every non-pre-release tag,
setting each platform's `url` and `sha256` to the new release's tarball. The
`brew test-bot` workflow installs and tests the formula on the pull request; merge it once
that passes.

To bump by hand, for each platform's tarball:

```sh
url=https://github.com/parsabee/PaykanLang/releases/download/vX.Y.Z/paykanlang-X.Y.Z-macos-arm64.tar.gz
curl -fsSL "$url.sha256"
```

and set that platform's `url` and `sha256` in `Formula/paykanlang.rb` (the release
attaches a `.sha256` beside each tarball).

## Repository settings

Settings → Actions → General → Workflow permissions: "Read and write permissions", so the
bottle workflow can push the bottle commit and publish to GitHub Packages. The compiler
repository's `RELEASE_CHANNELS_TOKEN` secret needs **Contents** and **Pull requests** write
access here to open the bump pull requests.
