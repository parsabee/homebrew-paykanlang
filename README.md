# Homebrew tap for PaykanLang

```sh
brew install parsabee/paykanlang/paykanlang
paykan --version
```

`brew install` taps this repository by itself; `brew tap parsabee/paykanlang` does it ahead
of time. The formula builds the core compiler from the release's source archive: the
recursive-descent frontend and the C backend, which compile programs with the system C
compiler. The release tarballs on the
[PaykanLang releases](https://github.com/parsabee/PaykanLang/releases) page also carry the
LLVM backend.

## How the formula is updated

The compiler's Release workflow opens a pull request here for every non-pre-release tag,
setting the formula's `url` and `sha256` to the new tag's source archive. The
`brew test-bot` workflow builds and tests the formula on the pull request and uploads the
bottles; adding the `pr-pull` label publishes the bottles to GitHub Packages and merges the
pull request with the formula's `bottle do` block filled in.

To bump by hand:

```sh
url=https://github.com/parsabee/PaykanLang/archive/refs/tags/vX.Y.Z.tar.gz
curl -fsSL "$url" | shasum -a 256
```

and set `url` and `sha256` in `Formula/paykanlang.rb`.

## Repository settings

Settings → Actions → General → Workflow permissions: "Read and write permissions", so the
bottle workflow can push the bottle commit and publish to GitHub Packages. The compiler
repository's `RELEASE_CHANNELS_TOKEN` secret needs **Contents** and **Pull requests** write
access here to open the bump pull requests.
