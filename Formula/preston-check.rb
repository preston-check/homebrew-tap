# Homebrew formula for Preston-Check
#
# Tap setup (one-time):
#   brew tap preston-check/tap
#
# Install:
#   brew install preston-check
#
# The version, URL, SHA256, and bottle block are updated by the release
# pipeline on each tagged release.

class PrestonCheck < Formula
  desc "Pre-deployment security audit for fintech and financial systems"
  homepage "https://preston-check.com"
  url "https://github.com/preston-check/preston-check/releases/download/v1.8.78/preston-check-1.8.78.tar.gz"
  sha256 "68a47fd190d048a739d134992913363fc5a13aaa94e731f8914ac59275a1d5fc"
  license "Apache-2.0"
  version "1.8.78"

  bottle do
    root_url "https://github.com/preston-check/preston-check/releases/download/v1.8.78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644830fb3a645602f8374663f3022082358b9a8d9c3fe891fb984a7bfaf77b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3aa7a51a990f14bb80f811b1b7c9b4897f265f96492a8e51bd30084451df75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be2d76e384e20cf1a06d5069c748adef3864baf963a1ffcebf63d5d2d53669d8"
    sha256 cellar: :any_skip_relocation, sequoia:       "081165dbfd1610dd609b19ed8045335e4183b50cbde85709160beae24b732546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ba66d6ea0f537ee64b401f33dcbe7c7ac21a3f06a13b4932df232a32879f22"
  end














































































  depends_on "bash"
  depends_on "gawk"
  depends_on "grep"
  depends_on "coreutils"
  uses_from_macos "openssl"

  def install
    libexec.install Dir["*"]
    {
      "preston-check"               => "preston-check.sh",
      "preston-check-issue-license" => "tools/issue-license.sh",
      "preston-check-setup-key"     => "tools/setup-signing-key.sh",
    }.each do |bin_name, script|
      (bin/bin_name).write <<~SH
        #!/bin/bash
        DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        exec "$DIR/../libexec/#{script}" "$@"
      SH
      chmod 0755, bin/bin_name
    end
  end

  def caveats
    <<~EOS
      Preston-Check is installed. Free tier runs without any setup.

      To run a scan in the current directory:
        preston-check

      To run with a specific config:
        preston-check --config /path/to/myapp.yml

      For Pro/Enterprise tier, install your license at:
        ~/.preston-check/license

      If brew install fails (e.g. on a beta macOS without a bottle yet):
        curl -fsSL https://github.com/preston-check/preston-check/releases/latest/download/install.sh | sh

      Documentation: https://preston-check.com
    EOS
  end

  test do
    assert_match "PRESTON-CHECK", shell_output("#{bin}/preston-check --help")
  end
end
