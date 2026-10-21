# Homebrew formula for PaykanLang: `brew install parsabee/paykanlang/paykanlang`.
#
# Installs the release's prebuilt tarball for the platform: paykan links LLVM
# statically, so a source build would download and link all of LLVM on the
# user's machine.  The tarball is the release workflow's `cmake --install`
# tree: paykan in bin/, the runtime archive in lib/, Runtime.h and
# plugin_api.h in include/paykan/, the standard library in
# lib/paykan/stdlib/<version>/ and an empty system plugin directory in
# lib/paykan/plugins/<version>/.  paykan finds its runtime and standard
# library next to itself; `paykan build` links with the system C compiler.
#
# The Release workflow of parsabee/PaykanLang opens a pull request that sets
# each platform's `url` and `sha256` for each release; see README.md.
class Paykanlang < Formula
  desc "Statically-typed, object-oriented language compiled with LLVM"
  homepage "https://github.com/parsabee/PaykanLang"
  license "MIT"

  on_macos do
    # The macOS release is built for Apple Silicon only, and the arch
    # requirement keeps an Intel Mac from installing it (brew wants a URL on
    # every macOS all the same).
    url "https://github.com/parsabee/PaykanLang/releases/download/v0.2.0/paykanlang-0.2.0-macos-arm64.tar.gz"
    sha256 "0562d33df6480a5bcfdcf76f2a05b77f93f6ecd18f02155ddf4b026e98349847"

    depends_on arch: :arm64
  end
  on_linux do
    on_intel do
      url "https://github.com/parsabee/PaykanLang/releases/download/v0.2.0/paykanlang-0.2.0-linux-x86_64.tar.gz"
      sha256 "45fc5e28f5f7516e9c89697d7822a5cf16200cca67dcc12d41608ebbc8677b36"
    end
    on_arm do
      url "https://github.com/parsabee/PaykanLang/releases/download/v0.2.0/paykanlang-0.2.0-linux-arm64.tar.gz"
      sha256 "0f8d61e2f45cc6b8070e4145b03a30b1409a39c7da631da5e0a403d5d2ba636c"
    end
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    # The installed compiler runs a program, and builds it into an executable
    # with the system C compiler against the installed runtime.  The program
    # prints nothing, so it is valid in every release: paykan exits with its
    # result, 42.
    (testpath/"answer.pkn").write <<~PKN
      fn main() -> int {
        x: int = 20;
        y: int = 22;
        return x + y;
      }
    PKN
    assert_match "PaykanLang #{version}", shell_output("#{bin}/paykan --version")
    shell_output("#{bin}/paykan #{testpath}/answer.pkn", 42)
    system bin/"paykan", "build", "-o", testpath/"answer", testpath/"answer.pkn"
    shell_output(testpath/"answer", 42)

    assert_path_exists lib/"libpaykan_runtime.a"
    assert_path_exists include/"paykan/Runtime.h"
  end
end
